import sys
import os
import shutil
import subprocess
import argparse
import json
import platform

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BIN_DIR = os.path.join(SCRIPT_DIR, "bin")
WORK_DIR = os.path.join(SCRIPT_DIR, "out")
IS_WINDOWS = platform.system() == "Windows"
BINARY_NAME = "magiskboot.exe" if IS_WINDOWS else "magiskboot"
MAGISKBOOT = os.path.join(BIN_DIR, BINARY_NAME)
MANIFEST_FILE = ".extract_manifest"
KERNEL_FILE = "kernel"
SHIM_FILE = "bootshim.bin"
FD_FILE = "extracted.fd"
TEMP_FILES = [KERNEL_FILE, SHIM_FILE, FD_FILE, "ramdisk.cpio", "kernel_dtb", "kernel_raw", "kernel_gzip", "new-boot.img"]

def log(msg, level="INFO"):
    if IS_WINDOWS:
        prefix = f"[{level}]"
    else:
        colors = {"INFO": "\033[94m[*]\033[0m", "SUCCESS": "\033[92m[+]\033[0m", "ERROR": "\033[91m[!]\033[0m", "WARN": "\033[93m[-]\033[0m"}
        prefix = colors.get(level, '[*]')
    print(f"{prefix} {msg}")

def check_tools():
    if not os.path.exists(BIN_DIR):
        log(f"CRITICAL: 'bin' folder missing at {BIN_DIR}", "ERROR")
        sys.exit(1)

    if not os.path.exists(MAGISKBOOT):
        log(f"CRITICAL: '{BINARY_NAME}' not found in 'bin' folder.", "ERROR")
        sys.exit(1)
    
    if not IS_WINDOWS:
        if not os.access(MAGISKBOOT, os.X_OK):
            try: 
                os.chmod(MAGISKBOOT, 0o755)
            except OSError:
                log("Permission denied: cannot execute magiskboot.", "ERROR")
                sys.exit(1)

def run_magiskboot(args):
    try:
        subprocess.run([MAGISKBOOT] + args, cwd=WORK_DIR, capture_output=True, text=True, check=True)
    except subprocess.CalledProcessError as e:
        log(f"magiskboot failed: {' '.join(args)}\n{e.stderr}", "ERROR")
        sys.exit(1)

def cleanup_temp():
    for f in TEMP_FILES:
        path = os.path.join(WORK_DIR, f)
        if os.path.exists(path):
            try: os.remove(path)
            except OSError: pass

def unpack(image_path):
    log(f"Unpacking: {image_path}")
    image_abs = os.path.abspath(image_path)
    if not os.path.exists(image_abs):
        log("Image file not found.", "ERROR")
        sys.exit(1)

    if not os.path.exists(WORK_DIR): os.makedirs(WORK_DIR)
    
    # clean previous run
    manifest_path = os.path.join(WORK_DIR, MANIFEST_FILE)
    if os.path.exists(manifest_path): os.remove(manifest_path)
    cleanup_temp()

    run_magiskboot(["unpack", image_abs])

    # Verify extraction
    extracted_files = []
    possible_outputs = ["kernel", "ramdisk.cpio", "kernel_dtb", "second", "dtb", "extra", "recovery_dtbo"]
    
    for f in possible_outputs:
        if os.path.exists(os.path.join(WORK_DIR, f)):
            extracted_files.append(f)

    if "kernel" not in extracted_files:
        log("Unpack Error: 'kernel' file missing.", "ERROR")
        sys.exit(1)

    #  save manifest (what exactly must exist for repack)
    with open(manifest_path, "w") as f:
        json.dump(extracted_files, f)
    log(f"Verified {len(extracted_files)} extracted components.", "SUCCESS")

    # decompress Kernel (check gzip magic 1F 8B)
    kernel_path = os.path.join(WORK_DIR, KERNEL_FILE)
    kernel_raw_path = os.path.join(WORK_DIR, "kernel_raw")
    
    with open(kernel_path, 'rb') as f: magic = f.read(2)
    if magic == b'\x1f\x8b':
        run_magiskboot(["decompress", KERNEL_FILE, "kernel_raw"])
        shutil.move(kernel_raw_path, kernel_path)

    # split Shim/FD
    try:
        with open(kernel_path, 'rb') as f: data = f.read()
    except IOError:
        log("Failed to read kernel.", "ERROR")
        sys.exit(1)

    sig_offset = data.find(b'_FVH')
    if sig_offset == -1:
        log("No UEFI signature (_FVH) found. Is this a UEFI image?", "ERROR")
        sys.exit(1)

    split_point = sig_offset - 40
    
    shim_path = os.path.join(WORK_DIR, SHIM_FILE)
    fd_path = os.path.join(WORK_DIR, FD_FILE)

    with open(shim_path, 'wb') as f: f.write(data[:split_point])
    with open(fd_path, 'wb') as f: f.write(data[split_point:])

    log("Unpack complete.", "SUCCESS")
    log(f"Files saved to: {WORK_DIR}")

def repack(original_image):
    log("Repacking...")
    original_abs = os.path.abspath(original_image)
    if not os.path.exists(WORK_DIR):
        log("Out folder missing. Run unpack first.", "ERROR")
        sys.exit(1)

    manifest_path = os.path.join(WORK_DIR, MANIFEST_FILE)
    if not os.path.exists(manifest_path):
        log("Manifest missing. Run unpack first.", "ERROR")
        sys.exit(1)

    with open(manifest_path, "r") as f:
        required_files = json.load(f)

    # check files
    for f in required_files:
        if f == "kernel": continue
        if not os.path.exists(os.path.join(WORK_DIR, f)):
            log(f"Missing file: {f}", "ERROR")
            sys.exit(1)

    shim_path = os.path.join(WORK_DIR, SHIM_FILE)
    fd_path = os.path.join(WORK_DIR, FD_FILE)
    kernel_path = os.path.join(WORK_DIR, KERNEL_FILE)
    kernel_gzip_path = os.path.join(WORK_DIR, "kernel_gzip")

    if not os.path.exists(shim_path) or not os.path.exists(fd_path):
        log(f"Missing {SHIM_FILE} or {FD_FILE}", "ERROR")
        sys.exit(1)

    # merge Shim + FD
    try:
        with open(shim_path, 'rb') as f: shim = f.read()
        with open(fd_path, 'rb') as f: fd = f.read()
        with open(kernel_path, 'wb') as f: f.write(shim + fd)
    except IOError as e:
        log(f"Merge failed: {e}", "ERROR")
        sys.exit(1)

    # ccompress
    run_magiskboot(["compress=gzip", KERNEL_FILE, "kernel_gzip"])
    shutil.move(kernel_gzip_path, kernel_path)
    
    # Repack using original header
    if not os.path.exists(original_abs):
        log("Original image missing.", "ERROR")
        sys.exit(1)

    run_magiskboot(["repack", original_abs])

    new_boot_internal = os.path.join(WORK_DIR, "new-boot.img")
    if os.path.exists(new_boot_internal):
        final_dest = os.path.join(SCRIPT_DIR, "new-boot.img")
        if os.path.exists(final_dest): os.remove(final_dest)
        shutil.move(new_boot_internal, final_dest)
        
        log(f"Success! Output: {final_dest}", "SUCCESS")
        log("Cleaning up workspace...", "INFO")
        run_magiskboot(["cleanup"])
        cleanup_temp()
        if os.path.exists(manifest_path): os.remove(manifest_path)
        
    else:
        log("Repack failed.", "ERROR")
        sys.exit(1)

def main():
    check_tools()
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="mode", required=True)

    p_un = subparsers.add_parser("unpack")
    p_un.add_argument("image")

    p_re = subparsers.add_parser("repack")
    p_re.add_argument("original_image")

    args = parser.parse_args()
    try:
        if args.mode == "unpack": unpack(args.image)
        elif args.mode == "repack": repack(args.original_image)
    except KeyboardInterrupt:
        sys.exit(1)
    except Exception as e:
        log(f"Error: {e}", "ERROR")
        sys.exit(1)

if __name__ == "__main__":
    main()