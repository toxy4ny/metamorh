#!/bin/bash

EMERALD="\033[1;32m"
RESET="\033[0m"

echo -e "${EMERALD}                                                          ${RESET}"
echo -e "${EMERALD}   \\  |  __| __ __|  \\     \\  |   _ \\  _ \\  _ \\ |  |${RESET}"
echo -e "${EMERALD}  |\\/ |  _|     |   _ \\   |\\/ |  (   |   /  __/ __ |   ${RESET}"
echo -e "${EMERALD} _|  _| ___|   _| _/  _\\ _|  _| \\___/ _|_\\ _|  _| _|   ${RESET}"
echo -e "${EMERALD}                                                          ${RESET}"
echo -e "${EMERALD} a Python Requirements.txt to install in Archlinux        ${RESET}"
echo -e "${EMERALD} by KL3FT3Z (https://github.com/toxy4ny)                  ${RESET}"

install_requirements_from_arch() {
    local requirements_file="requirements.txt"
    
    if [[ ! -f $requirements_file ]]; then
        echo "[ERROR] File $requirements_file not found."
        exit 1
    fi

    local packages=()
    
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
        
        package_name=$(echo "$line" | sed 's/[>=<].*//')
        
        arch_package="python-${package_name//_/-}"
        packages+=("$arch_package")
    done < "$requirements_file"

    for package in "${packages[@]}"; do
        echo "[INFO] Installing package: $package"
        if sudo pacman -S --needed --noconfirm "$package"; then
            echo "[INFO] Package $package Installed or already in Archlinux."
        else
            echo "[ERROR] Not found Package: $package"
            echo "[INFO] Package search using pacman -Ss..."
            pacman -Ss "python-${package_name//_/-}"
            
            echo "[INFO] Check out the above options or consider installing from the AUR."
        fi
    done
}

main() {
    install_requirements_from_arch
}

main

