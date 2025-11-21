
#!/bin/bash
# set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

echo
echo -e "${CYAN}========================================${RESET}"
echo -e "${CYAN}  Installing Visual Studio Code${RESET}"
echo -e "${CYAN}========================================${RESET}"
echo

sudo apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code 

echo
echo -e "${GREEN}========================================${RESET}"
echo -e "${GREEN}  Installing Google Chrome${RESET}"
echo -e "${GREEN}========================================${RESET}"
echo

wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > google-chrome.gpg
sudo install -D -o root -g root -m 644 google-chrome.gpg /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
rm -f google-chrome.gpg

sudo apt update
sudo apt install -y google-chrome-stable

echo
echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW}  Installing GNOME Control Center & Git${RESET}"
echo -e "${YELLOW}========================================${RESET}"
echo

sudo apt install -y gnome-control-center git

echo
echo -e "${MAGENTA}========================================${RESET}"
echo -e "${MAGENTA}  Installing ROS 2 Jazzy & Gazebo Harmonic${RESET}"
echo -e "${MAGENTA}========================================${RESET}"
echo
sudo apt install -y software-properties-common curl
sudo add-apt-repository universe -y
sudo apt update

curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o ros-archive-keyring.gpg
sudo install -D -o root -g root -m 644 ros-archive-keyring.gpg /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
rm -f ros-archive-keyring.gpg

wget -qO- https://packages.osrfoundation.org/gazebo.gpg | gpg --dearmor > gazebo-keyring.gpg
sudo install -D -o root -g root -m 644 gazebo-keyring.gpg /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
rm -f gazebo-keyring.gpg

sudo apt update
sudo apt install -y ros-jazzy-desktop ros-jazzy-ros-gz gz-harmonic ros-dev-tools

echo
echo -e "${RED}========================================${RESET}"
echo -e "${RED}  Setting Login Screen${RESET}"
echo -e "${RED}========================================${RESET}"
echo
cp logo/ROSuntu_logo-small.png /usr/share/pixmaps/ubuntu-logo.png
cp logo/ROSuntu_logo.png /usr/share/pixmaps/ubuntu-logo-text.png

echo
echo -e "${WHITE}========================================${RESET}"
echo -e "${WHITE}  Configuring Installer Slideshow${RESET}"
echo -e "${WHITE}========================================${RESET}"
echo
rm -rf /usr/share/desktop-provision/slides
mkdir -p /usr/share/desktop-provision/slides
cp -r slides/* /usr/share/desktop-provision/slides/

echo
echo -e "${CYAN}========================================${RESET}"
echo -e "${CYAN}  Preparing Wallpapers${RESET}"
echo -e "${CYAN}========================================${RESET}"
echo
mkdir -p /usr/share/backgrounds/rosuntu
cp wallpaper/*.png /usr/share/backgrounds/rosuntu/
cp wallpaper/rosuntu-wallpapers.xml /usr/share/gnome-background-properties/rosuntu-wallpapers.xml

echo
echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW}  Preparing Plymouth${RESET}"
echo -e "${YELLOW}========================================${RESET}"
echo
mkdir -p /usr/share/plymouth/themes/rosuntu
cp plymouth/*.png /usr/share/plymouth/themes/rosuntu/
cp plymouth/rosuntu.script /usr/share/plymouth/themes/rosuntu/
cp plymouth/rosuntu.plymouth /usr/share/plymouth/themes/rosuntu/
update-alternatives --install "/usr/share/plymouth/themes/default.plymouth" "default.plymouth" "/usr/share/plymouth/themes/rosuntu/rosuntu.plymouth" 160

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE}  Configuring Defaults${RESET}"
echo -e "${BLUE}========================================${RESET}"
echo
cp conf/90_ubuntu-settings.gschema.override /usr/share/glib-2.0/schemas/
glib-compile-schemas /usr/share/glib-2.0/schemas
mkdir -p /etc/dconf/profile
cp conf/dconf-profile-user /etc/dconf/profile/user
mkdir -p /etc/dconf/db/local.d
cp conf/00-favorite-apps /etc/dconf/db/local.d/00-favorite-apps
cp conf/01-background /etc/dconf/db/local.d/01-background
dconf update

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE}  Installing Docker${RESET}"
echo -e "${BLUE}========================================${RESET}"
echo
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io \
docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER

echo
echo -e "${GREEN}========================================${RESET}"
echo -e "${GREEN}  Configuring .bashrc${RESET}"
echo -e "${GREEN}========================================${RESET}"
echo
echo "source /opt/ros/jazzy/setup.bash" >> /etc/skel/.bashrc