add_repo(){
  # add_repo function enables 3rd party repositories
  echo "Looking for 'contrib' && 'non-free' repositories..."
  if [ "`grep -n contrib /etc/apt/sources.list`" ]; then
    echo "'contrib' && 'non-free' repositories found!"
  else
    echo "Adding 'contrib' && 'non-free' repositories..."
    sed -i '/buster/ s/$/ contrib non-free/' /etc/apt/sources.list
  fi

  echo "Looking for CISOfy repository..."
  if [ "`grep -n lynis /etc/apt/sources.list`" ]; then
    echo "CISOfy repositories found!"
  else
    echo "Adding 'CISOfy' repository..."
    curl -sL https://packages.cisofy.com/keys/cisofy-software-public.key | apt-key add - &> /dev/null
    echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" >> /etc/apt/sources.list
  fi

  echo "Looking for NodeJS repositories..."
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
        echo "Nothing was selected..."
        ;;
    esac
  fi

  echo "Looking for Atom.io repository..."
  if [ "`grep -n AtomEditor /etc/apt/sources.list`" ]; then
    echo "Atom.io repository found!"
  else
    echo "Adding Atom.io repository..."
    curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add - &> /dev/null
    echo "deb https://packagecloud.io/AtomEditor/atom/any/ any main" >> /etc/apt/sources.list
  fi

  echo "Looking for Slack repository..."
  if [ "`grep -n slacktechnologies /etc/apt/sources.list`" ]; then
    echo "Slack repository found!"
  else
    echo "Adding Slack repository..."
    curl -sL https://packagecloud.io/slacktechnologies/slack/gpgkey | apt-key add - &> /dev/null
    echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" >> /etc/apt/sources.list
  fi
}

add_repo
