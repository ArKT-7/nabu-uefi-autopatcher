# 🎨 UEFI Logo Changer Guide

A step-by-step guide to extracting, modifying, and repacking uefi.img with your new Boot Logo.

## 🛠️ Tools Needed

Before starting, download the required tools:

1.  **UEFI Autopatcher (This Repo):**
    * **Web Tool:** [Launch UEFI - FD Repacker](https://arkt-7.github.io/nabu-uefi-autopatcher/)
    * **CLI Tool:** [uefi_fd_repacker.py](https://github.com/ArKT-7/nabu-uefi-autopatcher/blob/main/uefi_fd_repacker.py)
2.  **UEFITool (For editing the logo):**
    * 🐧 **Linux:** [Download uefitool](https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/UEFITool)
    * 🪟 **Windows:** [Download uefitool.exe](https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/UEFITool.exe)
    * *Note: On Linux, ensure you run `chmod +x uefitool` after downloading.*

---

## 🚀 Step 1: Extract the FD File

You need to extract the `extracted.fd` file from your `uefi.img`. Choose one method below:

### 🌐 Option A: Web Tool (Easiest)
1.  Go to the [UEFI Forge Web Tool](https://arkt-7.github.io/nabu-uefi-autopatcher/).
2.  Under **"1. SOURCE IMAGE"**, click to load your original `uefi.img`.
3.  Wait for the process to finish.
4.  Click **DOWNLOAD** next to `extracted.fd`.

### 💻 Option B: CLI Tool
1.  Place your `uefi.img` in the same folder as `uefi_fd_repacker.py`.
2.  Open your terminal/command prompt.
3.  Run the unpack command:
    ```bash
    python uefi_fd_repacker.py unpack path/to/uefi.img
    ```
4.  You will find the `extracted.fd` file inside the `out/` folder.

---

## 🎨 Step 2: Change the Logo using UEFITool

Now that you have the `extracted.fd` file, let's change the picture.

1.  Open **UEFITool** (`uefitool.exe` or `./uefitool`).
2.  Click **File** > **Open image file...**
3.  Select your `extracted.fd`.
4.  Click **File** > **Search...**
5.  Switch to the **GUID** tab and paste this exact ID:
    ```text
    7BB28B99-61BB-11D5-9A5D-0090273FC14D
    ```
6.  Click **OK**.
7.  Look at the bottom **"Messages"** pane. You will see a result saying *"GUID pattern ... found"*.
8.  **Double-click** that message. The tool will automatically jump to the correct section in the structure tree.
9.  Double-click the selected line to expand it until you see a **"Raw section"**.
10. **Right-click** on the "Raw section".
11. Choose **Replace body...**
12. Change the file filter to **"All Files"** and select your new **Logo (`.bmp`)** file.
    * *Note: Ensure your BMP is the correct resolution for your device.*
13. **Save the file:**
    * Click **File** > **Save image file...**
    * Save it as `new.fd`.

> **💡 Tip:** If you want to see the *current* logo first, choose **Extract body...** instead of Replace, save it as `original.bmp`, and open it on your PC.

---

## 📦 Step 3: Repack the Image

Now combine your modified `new.fd` back into a bootable image.

### 🌐 Option A: Web Tool
1.  Go back to the [UEFI Forge Web Tool](https://arkt-7.github.io/nabu-uefi-autopatcher/).
2.  Scroll down to **"2. REPACK NEW IMAGE"**.
3.  Upload your modified `new.fd` file.
4.  The tool will automatically forge the new image.
5.  Click **DOWNLOAD NEW-UEFI.IMG**.

### 💻 Option B: CLI Tool
1.  Rename your modified `new.fd` to `extracted.fd`.
2.  Move/replace it into the `out/` folder (overwrite the old one if it exists).
3.  Run the repack command:
    ```bash
    python uefi_fd_repacker.py repack path/to/uefi.img
    ```
    *(Note: The script needs the original `uefi.img` path to copy the header/ramdisk).*
4.  Your final image will be saved as `new-boot.img` in the main folder.



### 🎉 Done!
Flash your new image to your device:
```bash
fastboot boot new-uefi.img
```

---

### 🤝 Credits

* **[UEFITool](https://github.com/LongSoft/UEFITool):** An essential tool for parsing, extracting, and modifying the UEFI img...