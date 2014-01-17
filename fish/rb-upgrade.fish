function rb-upgrade -d "Brings core tools and configuration up to date" 

  mkdir -p /ragebmc/flags
  touch /ragebmc/flags/first-upgrade

  crow notice "Ensuring tools, logs & sites folder"
  mkdir -p /ragebmc/series
  mkdir -p /ragebmc/movies
  mkdir -p /ragebmc/incomplete
  mkdir -p /ragebmc/resources

  crow notice "Pull most recent changes from remote git"
  git pull

  crow notice "Install default toolset"
  sudo apt-get -y install htop build-essential zip figlet toilet 

  crow notice "Update fish auto-completitions"
  fish_update_completions 

  crow success "Finished ds-upgrade proccess"

end
