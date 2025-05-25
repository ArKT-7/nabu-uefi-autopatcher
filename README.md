# nabu-uefi-autopatcher
A one-command UEFI Dual Boot Kernel patcher for Xiaomi Pad 5 (Nabu) that installs UEFI Aloha or EDK2 boot menu without the need to flash any ZIP files or enter recovery mode. Fully automated and runs directly from Termux or shell.
## Test runs - copy and paste in termux with root access

### For Magnetic cover DBKP based Aloha Windows UEFI 
```bash
su -c "cd / && mkdir -p /dev/tmp && cd /dev/tmp && curl -sSL -o Aloha_uefi_Patcher https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/Aloha_uefi_Patcher && chmod 777 Aloha_uefi_Patcher && su -c ./Aloha_uefi_Patcher"
```

### For EDK2 Boot menu UEFI 
```bash
su -c "cd / && mkdir -p /dev/tmp && cd /dev/tmp && curl -sSL -o EDK2_uefi_Patcher https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/EDK2_uefi_Patcher && chmod 777 EDK2_uefi_Patcher && su -c ./EDK2_uefi_Patcher"
```