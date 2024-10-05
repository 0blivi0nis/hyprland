# ------------------------------------------------------
# Select AUR Helper
# ------------------------------------------------------

aur_helper=""

_selectAURHelper() {
    echo ":: Please select your preferred AUR Helper"
    echo
    aur_helper=$(gum choose "yay" "paru" "pikaur" "trizen" "aurman" "pacaur" "pakku" "advanced")
    if [ -z $aur_helper ] ;then
        _selectAURHelper
    fi

    if [ "$aur_helper" == "advanced" ] ; then
    	if gum confirm "This option is for non-wrapper helpers only, are you sure you want to continue?"; then
    		echo "Make sure the packages in the share/packages/general.sh & share/packages/hyprland.sh are installed"
            if gum confirm "Are you sure you want to continue?"; then
                echo "Continuing.."
            else
                exit 1
            fi
    	else
    		_selectAURHelper
    	fi
    elif command -v "$aur_helper" &> /dev/null; then
        echo ":: $aur_helper is already installed."
        return 0
    else
        echo ":: Installing $aur_helper..."
        cd $HOME
        if [ -d "$HOME/$aur_helper" ]; then
            rm -rf "$HOME/$aur_helper"
        fi
        git clone "https://aur.archlinux.org/$aur_helper.git" ~/$aur_helper || { echo ":: Failed to clone $aur_helper."; return 1; }
        cd $HOME/"$aur_helper" || { echo ":: Failed to change directory to $aur_helper."; return 1; }
        makepkg -si --noconfirm || { echo ":: Installation of $aur_helper failed."; return 1; }
        cd $HOME
        rm -rf "$aur_helper"
        echo ":: $aur_helper installed successfully."
    fi
}

if [[ $(_check_update) == "false" ]] ;then
    echo -e "${GREEN}"
    figlet -f smslant "AUR Helper"
    echo -e "${NONE}"
    _selectAURHelper
fi