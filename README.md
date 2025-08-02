# Nabu Dual Boot Kernel Patcher for Windows UEFI
## One-line command Dual Boot Kernel patcher for Xiaomi Pad 5 (Nabu)
### Installs UEFI based on the Aloha project to boot Windows using magnetic case or volume button methods, Includes extra logo options and requires no flashing of ZIP files or entering recovery mode, Fully automated and runs directly from `Termux` or `adb shell`
---
## Installation:
---
## Method 1 – Using your Pad 5 with root access (Android)
- **required `Root` Access on Android**
---
### 1. Install Termux apk
## `>_` [Downlaod Termux app](https://f-droid.org/repo/com.termux_1000.apk)

### 2. Open Termux app and copy-paste / run this command:
> [!WARNING]
> - **if you have ever used the DBKP boot image before or are currently using it,**
> - **please flash the stock Android `boot.img` first before continuing (do NOT use DBKP boot).**

> [!Important]
> - **Make sure to give superuser (root) permission to Termux/shell app in KSU or Magisk**
```bash
su -c "cd / && mkdir -p /dev/arkt && cd /dev/arkt && curl -sSLO https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/dbkp_uefi_patcher && chmod +x * && su -c ./dbkp_uefi_patcher"
```
> [!NOTE]
> - **Use this command if upper one not work**
```bash
cd ~ && arkt=https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main && mkdir -p arkt && cd arkt && curl -sSLO $arkt/dbkp_uefi_patcher && curl -sSLO $arkt/bin/curl && chmod +x * && su -c "export PATH=\$PWD:\$PATH && ./dbkp_uefi_patcher"
```
## Done!
---
## Method 2 – Using your PC with boot.img file (Windows)
- **required stock `boot.img` of Android**
---
> [!WARNING]
> - **Please provide the stock boot.img (DO NOT provide a DBKP boot image)**

### 1. Open **`Terminal/PowerShell or CMD`** in your Windows pc:
### 2. copy-paste and run this command:
```bash
powershell.exe -C "irm https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/dbkp_uefi_patcher.ps1 | iex"
```
## Done!
---
## How to use dualboot:

### 1. If using **Magnetic Case** method:

> [!NOTE]
> #### Boot into **Windows**:
> - Close the **magnetic case** and reboot (or power on) your device.
> #### Boot into **Android**:
> - Open the **magnetic case** and reboot (or power on) your device.

### 2. If using **Volume Button** method:

> [!NOTE]
> #### Boot into **Windows**:
> - Reboot (or power on) your device and **hold any volume button** once you see the unlock icon or just after the Mi logo.
> #### Boot into **Android**:
> - Simply **don’t press any volume button** while rebooting or powering on the device.
> #### Boot into **Recovery**:
> - First, **do not press any button** when the Mi logo first appears and then your choosed uefi logo apprear — the screen will turn off and on.
> - When screen on and the **Mi logo appears again** (indicating Android boot), **press and hold Volume Up** immediately — recovery will then launch.

## Finished!

## These are the logos available as of now:
> [!NOTE]
> - **If Need help, have questions, or want to add your own logo? reach out to me on Telegram:** 
> - [![Telegram](https://img.shields.io/badge/Chat-Telegram-brightgreen.svg?logo=telegram&style=flat-square)](https://telegram.me/ArKT_7) [![Telegram](https://img.shields.io/badge/Chat-Telegram-brightgreen.svg?logo=telegram&style=flat-square)](https://t.me/ArKT_7)

| **1. Aloha Inverted V (Official)** | **2. Windows 11 White Square** | **3. Windows 11 Gradient Rounded** |
|------------------------------------|--------------------------------|--------------------------------|
| <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/aloha-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Aloha-official-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Win11-White-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/W11-White-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/win11-gradient-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/W11-Gradient-BootLogo.bmp" width="280"></a></p> |
| [**`Download Aloha V uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/aloha_UEFI_SB.img) |[**`Download Win 11 white uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Win11-White_UEFI_SB.img) | [**`Download Win 11 Gradient uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/win11-gradient_UEFI_SB.img) |

| **4. Nyanko Sensei (Madara)** | **5. SirTorius M logo** | **6. JadeKubPom logo** |
|------------------------------------|--------------------------------|--------------------------------|
| <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Nyanko-Sensei-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Nyanko-Sensei-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/SirTorius-M-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/M-for-SirTorius-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/JadeKubPom-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/JadeKubPom-BootLogo.bmp" width="280"></a></p> |
| [**`Download Nyanko Sensei uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Nyanko-Sensei_UEFI_SB.img) |[**`Download SirTorius M uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/SirTorius-M_UEFI_SB.img) | [**`Download JadeKubPom uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/JadeKubPom_UEFI_SB.img) |

| **7. Cambodia Porl Logo** | **8. Xiaomi Logo** | **9. MI Orange Logo** |
|------------------------------------|--------------------------------|--------------------------------|
| <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Cambodia-porl-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Cambodia-for-porl-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Xiaomi-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Xiaomi-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/MI-Orange-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/MI-Orange-BootLogo.bmp" width="280"></a></p> |
| [**`Download Cambodia Porl uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Cambodia-porl_UEFI_SB.img) |[**`Download Xiaomi uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Xiaomi_UEFI_SB.img) | [**`Download MI Orange uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/MI-Orange_UEFI_SB.img) |

 **10. MI White Logo** | **11. WinDroid Logo** | **12. Chara Dreemurr Logo** |
|------------------------------------|--------------------------------|--------------------------------|
| <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/MI-white-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/MI-White-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/WinDroid-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/WinDroid-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Chara-Dreemurr-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Chara-Dreemurr-BootLogo.bmp" width="280"></a></p> |
| [**`Download MI White uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/MI-White_UEFI_SB.img) |[**`Download WinDroid uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/WinDroid_UEFI_SB.img) | [**`Download Chara Dreemurr uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Chara-Dreemurr_UEFI_SB.img) |

 **13. Storyswap Chara Logo** | **14. Yakumo Yukari Logo** | **15. Ralsei Logo** |
|------------------------------------|--------------------------------|--------------------------------|
| <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Storyswap-Chara-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Storyswap-Chara-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Yakumo-Yukari-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Yakumo-Yukari-BootLogo.bmp" width="280"></a></p> | <p align="center"><a href="https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Ralsei-uefi-nabu.zip"><img src="/bin/aloha/uefi-img-files/Custom-logos/Ralsei-BootLogo.bmp" width="280"></a></p> |
| [**`Download Storyswap Chara uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Storyswap-Chara_UEFI_SB.img) |[**`Download Yakumo Yukari uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Yakumo-Yukari_UEFI_SB.img) |[**`Download Ralsei uefi.img`**](https://raw.githubusercontent.com/ArKT-7/nabu-uefi-autopatcher/refs/heads/main/bin/aloha/uefi-img-files/Ralsei_UEFI_SB.img) |
