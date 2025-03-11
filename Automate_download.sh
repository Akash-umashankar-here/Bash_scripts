#!/bin/bash                             
# to use bash as shell

if command -v $1                        #checks whether the specified tool/package in command line as input exist
then 
echo "the package exist"

else
  echo "The package doesn't exist"
  echo "searching in apt..."

  if apt show $1 2>&1 | grep "No packages found" > /dev/null # checking whether the current apt's repository can install the package 
  then 
    echo "current apt can't download the specified package"

    echo "checking for the package can be downloaded via apt update..."

    if curl -Ls https://http.kali.org/kali/dists/kali-rolling/main/binary-amd64/Packages.gz | gunzip | grep -i '^Package: $1' #searching whether apt is capable of installing the package by checking the packages file in kali-rolling
    then 
      echo "The package can be installed after repository update"
    else
      echo "The package cannot be downloaded by apt"
      read -n 1 -p "if you want to search in github: " reply      # prompting the user to search in github asking y/n
      if [ "$reply" == "y" ]
      then
       curl -s "https://api.github.com/search/repositories?q=$1" | jq '.items[] | {name, html_url, description}'
      else 
       echo -e "\nThank you"
      fi
   fi
  else
   sudo apt install $1
  fi
fi



