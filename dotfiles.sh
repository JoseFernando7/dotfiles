# !/bin/zsh


start_script() {
  setup
  menu
  vscode_setup
  flatpak_setup
  nvm_setup
}

# ============================================ SETUP SECTION ============================================
setup() {
  echo "============================================="
  echo "|| INSTALLING PREREQUISITE CONFIGS...      ||"
  echo "============================================="

  sudo apt update
  sudo apt install curl
  sudo apt install wget
  sudo apt install lolcat
}
# ============================================ SETUP SECTION ============================================


# ============================================ MENU SECTION ============================================
menu() {
  echo "    ___  ________  ________       ________  ________  _________   ________  ___  ___       _______   ________       " | lolcat
  echo "   |\  \|\  _____\ \_____  \     |\   ___ \|\   __  \|\___   ___\|\  _____\|\  \|\  \     |\  ___ \ |\   ____\      " | lolcat
  echo "   \ \  \ \  \__/   \|___/ /|    \ \  \_|\ \ \  \|\  \|___ \  \_ \ \  \__/ \ \  \ \  \    \ \   __/|\ \  \___|_     " | lolcat
  echo " __ \ \  \ \   __\     /  / /     \ \  \  \ \ \  \ \  \   \ \  \  \ \   __\ \ \  \ \  \    \ \  \_|/_\ \_____  \    " | lolcat
  echo "|\ \___\  \ \  \_|    /  / /       \ \  \__\ \ \  \_\  \   \ \  \  \ \  \_|  \ \  \ \  \____\ \  \_|\ \|____|\  \   " | lolcat
  echo "\ \________\ \__\    /__/ /         \ \_______\ \_______\   \ \__\  \ \__\    \ \__\ \_______\ \_______\____\_\  \  " | lolcat
  echo " \|________|\|__|    |__|/           \|_______|\|_______|    \|__|   \|__|     \|__|\|_______|\|_______|\_________\ " | lolcat
  echo "                                                                                                        \|_________|" | lolcat
}
# ============================================ MENU SECTION ============================================


# ============================================ VS CODE SECTION ============================================
vscode_setup() {
  # Get the latest version from github API
  get_latest_version() {
    curl --silent "https://api.github.com/repos/microsoft/vscode/releases/latest" | jq -r '.tag_name'
  }

  get_installed_version() {
    code --version | head -n 1
  }

  download_vscode() {
    local latest_version=$1
    local url="https://update.code.visualstudio.com/${latest_version}/linux-deb-x64/stable"

    echo "Downloading VS Code version ${latest_version}..."
    wget -O vscode.deb $url

    echo "Installing VS Code..."
    sudo dpkg -i vscode.deb
    sudo apt-get install -f
    rm vscode.deb
  }

  install_vscode() {
    # Check versions and update if necessary
    latest_version=$(get_latest_version)
    installed_version=$(get_installed_version)

    echo "Latest VS Code version: $latest_version"
    echo "Installed VS Code version: $installed_version"

    if [ "$latest_version" != "$installed_version" ]; then
      echo "Updating VS Code..."
      download_vscode $latest_version
    else
      echo "VS Code is up to date"
    fi
  }
}
# ============================================ VS CODE SECTION ============================================


# ============================================ FLATPAK SECTION ============================================
flatpak_setup() {
  install_flatpak() {
    # Install flatpak
    sudo apt install flatpak

    # Install the flatpak software plugin for gnome
    sudo apt install gnome-software-plugin-flatpak

    # Add the flathub repository
    echo "Adding the flathub repository to the system..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    echo "================================================================"
    echo "|| CONSIDER REBOOT YOUR SYSTEM IN ORDER TO COMPLETE THE SETUP ||"
    echo "================================================================"
  }
}
# ============================================ FLATPAK SECTION ============================================


# ============================================ NVM SECTION ============================================
nvm_setup() {
  install_nvm() {
    echo "Downloading and installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

    # Cargar nvm a la ruta
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo -e "\nNVM VERSION INSTALLED:  "
    nvm_version=$(nvm --version)
    echo "$nvm_version"

    echo -e "\nInstalling lts node and npm version"
    nvm install --lts

    echo -e "\nNODE AND NPM VERSION INSTALLED:  "
    node_version=$(node --version)
    node --version
    npm --version

    echo -e "\nEstablishing the node and npm version by default..."
    nvm alias default $node_version
  }
}
# ============================================ NVM SECTION ============================================


start_script

