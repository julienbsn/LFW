main(){

  check_pkgs
  add_repo

  echo "Updating repositories ..."
  apt update -y 2> /dev/null

  install_pkgs
  ufw_config

  echo "upgrading system ..."
  apt upgrade -y 2> /dev/null

  echo "clearing unnescessary packages ..."
  apt autoremove -y 2> /dev/null

  echo "System's ready!"
}

main
