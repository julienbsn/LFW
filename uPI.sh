#!/bin/bash


check_pkgs(){
  # check_pkgs function ensures that the required packages are already present
  echo "Checking cURL ..."
  if [ "$(dpkg-query -l curl | grep ^i)" 2> /dev/null ]; then
    echo "cURL package found!"
  else
    echo "Installing cURL ..."
    apt install -y curl &> /dev/null
  fi

  echo "Checking GnuPG ..."
  if [ "$(dpkg-query -l gnupg | grep ^i)" 2> /dev/null ]; then
    echo "GnuPG package found!"
  else
    echo "Installing GnuPG..."
    apt install -y gnupg &> /dev/null
  fi

  echo "Checking apt-transport-https ..."
  if [ "$(dpkg-query -l apt-transport-https | grep ^i)" 2> /dev/null ]; then
    echo "apt-transport-https package found!"
  else
    echo "Installing apt-transport-https ..."
    apt install -y apt-transport-https &> /dev/null
  fi

  echo "Checking debian-archive-keyring ..."
  if [ "$(dpkg-query -l debian-archive-keyring | grep ^i)" 2> /dev/null ]; then
    echo "debian-archive-keyring package found!"
  else
    echo "Installing debian-archive-keyring ..."
    apt install -y debian-archive-keyring &> /dev/null
  fi

  echo "Ready to go further!"
}

add_repo(){
  # add_repo function enables 3rd party repositories
  echo "Looking for 'contrib' && 'non-free' repositories ..."
  if [ "`grep -n contrib /etc/apt/sources.list`" ]; then
    echo "'contrib' && 'non-free' repositories found!"
  else
    echo "Adding 'contrib' && 'non-free' repositories ..."
    sed -i '/buster/ s/$/ contrib non-free/' /etc/apt/sources.list
  fi

  echo "Looking for CISOfy repository ..."
  if [ "`grep -n lynis /etc/apt/sources.list`" ]; then
    echo "CISOfy repositories found!"
  else
    echo "Adding 'CISOfy' repository ..."
    curl -sL https://packages.cisofy.com/keys/cisofy-software-public.key | apt-key add - &> /dev/null
    echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" >> /etc/apt/sources.list
  fi

  echo "Looking for NodeJS repositories ..."
  if [ -f /etc/apt/sources.list.d/nodesource.list ]; then
    # to do : check which version
    echo "NodeJS repositories found!"
  else
    echo "Adding NodeJS repositories..."
    printf "Which version do you want to use? [8.x/9.x] : "
    read -r node_version
    case $node_version in
      "8.x" )
        curl -sL https://deb.nodesource.com/setup_8.x | bash - &> /dev/null
        ;;
      "9.x" )
        curl -sL https://deb.nodesource.com/setup_9.x | bash - &> /dev/null
        ;;
      *)
        echo "Nothing was selected ..."
        ;;
    esac
  fi

  echo "Looking for Atom.io repository ..."
  if [ "`grep -n AtomEditor /etc/apt/sources.list`" ]; then
    echo "Atom.io repository found!"
  else
    echo "Adding Atom.io repository ..."
    curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add - &> /dev/null
    echo "deb https://packagecloud.io/AtomEditor/atom/any/ any main" >> /etc/apt/sources.list
  fi

  echo "Looking for Slack repository ..."
  if [ "`grep -n slacktechnologies /etc/apt/sources.list`" ]; then
    echo "Slack repository found!"
  else
    echo "Adding Slack repository ..."
    curl -sL https://packagecloud.io/slacktechnologies/slack/gpgkey | apt-key add - &> /dev/null
    echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" >> /etc/apt/sources.list
  fi
}

install_pkgs(){
  # install_pkgs function will setup a tiny workstation (minimalistic gnome3, privacy && some security essentials softwares)
  pkgs_list=()
  printf "Install pkgs_list? [Y/n] : "
  read -r pkgs_user_choice
  if [[ $pkgs_user_choice == "Y" ]] || [[ $pkgs_user_choice == "y" ]]; then
    for pkgs in "${pkgs_list[@]}"; do
      if [ "$(dpkg-query -l $pkgs | grep ^i)" 2> /dev/null ]; then
        echo "package $pkgs already installed!"
      else
        echo "Installing $pkgs package..."
        apt install -y $pkgs &> /dev/null
      fi
    done
  fi
}

ufw_config(){
  # ufw_config function provides a
  printf "allow outgoing? [Y/n] : "
  read -r allow_outgoing
  if [ $allow_outgoing = "Y" ] || [ $allow_outgoing = "y" ]; then
    ufw default allow outgoing
  fi

  printf "deny incoming? [Y/n] : "
  read -r deny_incoming
  if [ $deny_incoming = "Y" ] || [ $deny_incoming = "y" ]; then
    ufw default deny incoming
  fi

  printf "configure other rules? [Y/n] : "
  read -r conf_other
  # set very basic rules!
  if [[ $conf_other == "Y" ]] || [[ $conf_other == "y" ]]; then
    until [[ $conf_other_rules == "Y" ]] || [[ $conf_other_rules == "y" ]]; do
      printf "define status [allow/deny] : "
      read -r status
      printf "define stream [in/out] : "
      read -r stream
      printf "define port [0/65535] : "
      read -r port
      printf "define protocol [tcp/udp] : "
      read -r protocol
      ufw $status $stream $port/$protocol
      printf "Are you done? [Y/n] : "
      read -r conf_other_rules
    done
  else
    echo "firewall's setup is finished!"
  fi

  printf "enable ip forwarding? [Y/n] : "
  read -r enable_ip_forward
  if [[ $enable_ip_forward == "Y" ]] || [[ $enable_ip_forward == "y" ]]; then
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "restarting procps service ..."
    /etc/init.d/procps.sh restart
  fi

  printf "enable firewall at startup? [Y/n] : "
  read -r enable_startup
  if [ $enable_startup = "Y" ] || [ $enable_startup = "y" ]; then
    ufw enable
  else
    echo "firewall is configured but not enabled ..."
  fi
}

main(){

  echo "Checking required packages ..."
  check_pkgs

  echo "Adding new repositories ..."
  add_repo

  echo "Updating repositories ..."
  apt update -y &> /dev/null

  echo "Installing new packages ..."
  install_pkgs

  echo "Configuring firewall ..."
  ufw_config

  echo "upgrading system ..."
  apt upgrade -y &> /dev/null

  echo "Clearing unnescessary packages ..."
  apt autoremove -y &> /dev/null

  echo "System's ready!"
}

main
