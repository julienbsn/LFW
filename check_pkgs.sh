check_pkgs(){
  # check_pkgs function ensures that the required packages are already present
  echo "Checking cURL..."
  if [ "$(dpkg-query -l curl | grep ^i)" 2> /dev/null ]; then
    echo "cURL package found!"
  else
    echo "Installing cURL..."
    apt install -y curl &> /dev/null
  fi

  echo "Checking GnuPG..."
  if [ "$(dpkg-query -l gnupg | grep ^i)" 2> /dev/null ]; then
    echo "GnuPG package found!"
  else
    echo "Installing GnuPG..."
    apt install -y gnupg &> /dev/null
  fi

  echo "Checking apt-transport-https..."
  if [ "$(dpkg-query -l apt-transport-https | grep ^i)" 2> /dev/null ]; then
    echo "apt-transport-https package found!"
  else
    echo "Installing apt-transport-https..."
    apt install -y apt-transport-https &> /dev/null
  fi

  echo "Checking debian-archive-keyring..."
  if [ "$(dpkg-query -l debian-archive-keyring | grep ^i)" 2> /dev/null ]; then
    echo "debian-archive-keyring package found!"
  else
    echo "Installing debian-archive-keyring..."
    apt install -y debian-archive-keyring &> /dev/null
  fi

  echo "Ready to go further!"
}

check_pkgs
