pkgs_list=("ufw" "curl" "git")

install_pkgs(){
  # install_pkgs function will setup a tiny workstation (minimalistic gnome3, privacy && some security essentials softwares)
  printf "Install pkgs_list? [Y/n] : "
  read -r pkgs_user_choice
  if [[ $pkgs_user_choice == "Y" ]] || [[ $pkgs_user_choice == "y" ]]; then
    for pkgs in "${pkgs_list[@]}"; do
      if [[ "$(dpkg-query -l $pkgs &> /dev/null)" -eq 0 ]]; then
        echo "package $pkgs already installed!"
      else
        echo "Installing $pkgs package..."
        apt install -y $pkgs &> /dev/null
      fi
    done
  fi
}

install_pkgs
