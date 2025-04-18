# Bash_scripts
1. Automate_download:
 download the script and give executable permission, execute the script by passing the package name you like to install
 #./Automate_download <package name>
 it will check whether the package already exist, if not whether it can be downloaded by th current apt(means repositories that already exist)
 if not whether it can be downloaded after a repository update, else it will show like it can't be downloaded by apt.
 it finally prompts the user to check in github and returns the links and associated description.

2. sql_injection:
 download the script and give executable permission, execute the script by passing the target ip on which you are about to do sql injection.
 it will find the sql and nosql services running and downloads the necessary tools to take over the vulnerability.
 here sqlmap, sqlsus, jsql-injection and StealthNosql has be utilized for performing sql injection.
