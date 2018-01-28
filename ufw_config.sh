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
    echo "firewall's custom setup is finished!"
  fi

  printf "enable ip forwarding? [Y/n] : "
  read -r enable_ip_forward
  if [[ $enable_ip_forward == "Y" ]] || [[ $enable_ip_forward == "y" ]]; then
    echo 1 > /proc/sys/net/ipv4/ip_forward
  fi

  printf "enable firewall at startup? [Y/n] : "
  read -r enable_startup
  if [ $enable_startup = "Y" ] || [ $enable_startup = "y" ]; then
    ufw enable
  else
    echo "firewall is configured but not enabled ..."
  fi
}
