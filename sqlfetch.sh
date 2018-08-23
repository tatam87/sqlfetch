#!/bin/bash
read -p 'If you want to use ssh press 1 , for direct mysql connection press 2: ' connection
  if [[ $connection == 1 ]] ;
    then
    echo "----------------"
    printf "\033[0;33mWarning!!! This script will replace your existing schema and table\033[0m\n"
    printf "Username:\t\t$USER\n"
    printf "Current Directory:\t$PWD\n"
    echo "----------------"
    read -p 'remote HOST_USER: ' remoteuser
    echo "----------------"
    read -p 'SSH Port (if you dont know type 22): ' sshport
    echo "----------------"
    read -p 'Remote DATABASE_HOST: ' remotehost
    echo "----------------"
    read -p 'Remote SQL_USER: ' remotesqluser
    echo "----------------"
    read -p 'Remote SQL_PASSWORD: ' remotesqlpass
    echo "----------------"
    read -p 'Schema Name: ' schema
    echo "----------------"
    read -p 'Local SQL_USER: ' sqluser
    echo "----------------"
    read -p 'Local SQL_PASSWORD: ' sqlpass
    echo "----------------"
    printf "\nSSH passphrase or password for SSH:\n"
    ssh -tt  $remoteuser@$remotehost -p$sshport "mysqldump -u$remotesqluser -p$remotesqlpass --databases -B $schema > ~/$schema.sql"
    echo "----------------"
    printf "\n Dump was created! To fetch provide again the ssh passphrase or password\n"
    scp -P$sshport $remoteuser@$remotehost:~/$schema.sql $PWD
    echo "----------------"
    echo the $schema.sql was downloaded!
    mysql -u$sqluser -p$sqlpass < $schema.sql
    echo "----------------"
    echo "unless you saw mysql error the import of $schema was successful"
    printf "\nFor deleting remote dump file ~/$schema.sql provide again the ssh passphrase or password\n"
    ssh -tt $remoteuser@$remotehost -p$sshport "rm ~/$schema.sql"
    echo "Remote dump file deleted"
    echo "----------------"
    printf "\nNow deleting local dump file \n"
    rm $schema.sql
    printf "\033[0;32mFinished!!!\033[0m\n"
  elif [ $connection == 2 ] ;
    then
      printf "Username:\t\t$USER\n"
      printf "Current Directory:\t$PWD\n"
      printf "\033[0;33mWarning!!! This script will make dump of the schema that you request\033[0m\n"
      echo "Please provide the mysql connection credentials"
      read -p 'Remote SQL_USER: ' remotesqluser
      echo "----------------"
      read -p 'Remote SQL_PASSWORD: ' remotesqlpass
      echo "----------------"
      read -p 'Remote DATABASE_HOST: ' remotehost
      echo "----------------"
      read -p 'Schema Name: ' schema
      echo "----------------"
      read -p 'Local SQL_USER: ' sqluser
      echo "----------------"
      read -p 'Local SQL_PASSWORD: ' sqlpass
      echo "----------------"
      read -p 'mysql port (if you dont know type 3306): ' sqlport
      echo "----------------"
      printf "Now lets go and fetch the databases.\n"
      mysqldump -u$remotesqluser -h$remotehost -p$remotesqlpass  --databases -B $schema > $schema.sql
      echo "----------------"
      printf "\033[0;32mFinished dump $schema.sql on $PWD !!!\033[0m\n"
      mysql -u$sqluser -p$sqlpass $schema < $schema.sql
      echo "----------------"
      echo "Unless you saw mysql error the import of $schema.sql was successful"
      echo "----------------"
      printf "Now deleting the dump file.\n"
      rm $schema.sql
        printf "\033[0;32mFinished!!!\033[0m\n"
    else
      echo "Not a valid character. Now exiting"
fi
