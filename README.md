# Nabu Dual Boot Kernel Patcher for Windows UEFI
## One-line command Dual Boot Kernel patcher for Xiaomi Pad 5 (Nabu)
### Installs UEFI based on the Aloha project to boot Windows using magnetic case or volume button methods, Includes extra logo options and requires no flashing of ZIP files or entering recovery mode, Fully automated and runs directly from `Termux` or `adb shell`

### 1. Install Termux apk
## `>_` [Downlaod Termux app](https://f-droid.org/repo/com.termux_1000.apk)

### 2. Open Termux app and Type
> [!WARNING]
> - **Make sure to give superuser (root) permission to Termux/shell app in KSU or Magisk**
```bash
su -c "cd / && mkdir -p /dev/arkt && cd /dev/arkt && curl -sSLO https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/dbkp_uefi_patcher && chmod +x * && su -c ./dbkp_uefi_patcher"
```
> [!NOTE]
> - **Copy this command and Paste if upper one not work**
```bash
cd ~ && arkt=https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main && mkdir -p arkt && cd arkt && curl -sSLO $arkt/dbkp_uefi_patcher && curl -sSLO $arkt/bin/curl && chmod +x * && su -c "export PATH=\$PWD:\$PATH && ./dbkp_uefi_patcher"
```
