# nabu-uefi-autopatcher
A one-command UEFI patcher for Xiaomi Pad 5 (Nabu) that installs UEFI Aloha or EDK2 boot menu without the need to flash any ZIP files or enter recovery mode. Fully automated and runs directly from Termux or shell.
## Test run - copy and paste in termux with root access
```bash
su -c "cd / && mkdir -p /dev/tmp && cd /dev/tmp && curl -sSL -o EDK2_Patcher https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/EDK2_Patcher && chmod 777 EDK2_Patcher && su -c ./EDK2_Patcher"
```
