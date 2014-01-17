function rb-user -a name -d "Adds a user to this system"
  switch "$name"
    case ''
      crow error "Usage: rb-user <username>"
    case '*'      

      crow notice "Adding user to system"
      sudo adduser $name

      if test -d /home/$name 

        crow notice "Setting default group to 'ragebmc'"
        sudo usermod -g ragebmc $name  
 
        crow notice "Make git remember your credentials"
        sudo 'su -c "git config --global credential.helper cache" -s /bin/sh $name'

        crow success "User $name succesfully added"
        mkdir -p /ragebmc/flags
        touch /ragebmc/flags/first-user

     else

       crow notice "No user has been added"

     end

  end
end
