#!/bin/bash

#Colors
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

function checkRoot(){
  if [ "$EUID" -ne 0 ]; then
    echo -e "\n${red}[!] You are not root. Please, execute the program as root, since it needs root privileges!${end}\n"
    exit 1
  fi 
}

checkRoot

function ctrl_c(){
  echo -e "\n\n${red}[!] Terminating program...${end}\n"
  tput cnorm; exit 1
}

# Ctrl + C 
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${yellow}[+]${end}${gray} Usage: ${end}"
  echo -e "\n\t${purple}-i${end}${gray}) Specifies the IP Address.${end}"
  echo -e "\t${purple}-p${end}${gray}) Specifies the ports.${end}"
  echo -e "\t${purple}-o${end}${gray}) Shows the flags used for each option (fast/slow).${end}"
  echo -e "\t${purple}-h${end}${gray}) Shows the help panel.${end}"
  echo -e "\n${green}[+] By ne0mesys${end}"
}

function extractPorts () {
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')" 
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)" 
	echo -e "\n${green}[+]${end}${gray} Extracting information...${end}\n" > extractPorts.tmp
	echo -e "\t${green}[+]${end}${gray} IP Address:${end}${green} $ip_address${end}" >> extractPorts.tmp
	echo -e "\t${green}[+]${end}${gray} Open Ports:${end}${blue} $ports${end}\n" >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "${green}[+]${end}${gray} Ports copied to clipboard${end}\n" >> extractPorts.tmp
	bat extractPorts.tmp
	rm extractPorts.tmp
}

function continueScanning(){
  echo -e "\n${green}[+]${end}${gray} Continuing the scan...${end}"
  tput civis
  ports=$(xclip -selection clipboard -o)
  nmap -p$ports -sC -sV $machineIP -oN targeted -oX targetedXML >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    tput cnorm
    echo -e "\n${green}[+]${end}${gray} Second-stage scan finished and saved in files:${end}${green} targeted${end} and ${green}targetedXML${end}"
    echo -ne "\n${green}[+]${end}${gray} Do you want to see the file${end}${green} targeted${end}${gray}? (yes/no) ${end}" && read answer
    if [[ "$answer" == "yes" || "$answer" == "y" || "$answer" == "Yes" || "$answer" == "Y" ]]; then
      bat targeted -l java 
    fi 

  else 
    echo -e "\n${red}[!] There were NO ports detected: Please check the IP Address or if the Host is up!${end}"
    tput cnorm
    exit 1
  fi 
}

function scanIP(){
  machineIP="$1"

  echo -e "\n${yellow}[+]${end}${gray} IP selected for the scanning${end}${yellow} $machineIP${end}\n"
    
  echo -ne "${yellow}[+]${end}${gray} Do you want a quick scan? (yes/no) ${end}" && read result 

  if [[ "$result" == "yes" || "$result" == "Y" || "$result" == "y" || "$result" == "Yes" ]]; then

    echo -e "${end}\n${yellow}[+]${end}${gray} Started scanning the IP Address${end}${yellow} $machineIP${end}"
    tput civis
    ping -c 1 -W 5 "$machineIP" > /dev/null 2>&1

    if [ $? -eq 0 ]; then # If the host is woken up then continue...
      tput civis
      nmap -sC -sV --min-rate=5000 -sS -Pn -T4 $machineIP -oG allPorts > /dev/null 
      tput cnorm

      echo -e "\n${green}[+]${end}${gray} Scanning finished and saved in the file${end}${green} allPorts${end}\n"
      echo -ne "${green}[+]${end}${gray} Do you want to extract the content? (yes/no) ${end}" && read answer
      if [[ "$answer" == "yes" || "$answer" == "y" || "$answer" == "Yes" || "$answer" == "Y" ]]; then
          tput civis
          extractPorts allPorts
          tput cnorm

          echo -ne "\n${green}[+]${end}${gray} Do you want to continue with the Second-stage enumeration step? (yes/no) ${end}" && read secondAnswer
          if [[ "$secondAnswer" == "yes" || "$secondAnswer" == "y" || "$secondAnswer" == "Y" || "$secondAnswer" == "Yes" ]]; then
            continueScanning 
          fi 
      fi 
    else # If the host isn't woken up then exit...
      echo -e "\n\n${red}[!] The scan failed! Please, check the host is up or your network connection!${end}\n"
      tput cnorm
      exit 1
    fi 

  elif [[ "$result" == "no" || "$result" == "N" || "$result" == "n" ]]; then 

    echo -e "${end}\n${yellow}[+]${end}${gray} Started scanning the IP Address${end}${yellow} $machineIP${end}"
    tput civis
    ping -c 1 -W 5 "$machineIP" > /dev/null 2>&1

    if [ $? -eq 0 ]; then # If the host is woken up then continue...
      tput civis
      nmap -sC --open -sV -sS -p- $machineIP -oG allPorts > /dev/null
      tput cnorm

      echo -e "\n${green}[+]${end}${gray} Scanning finished and saved in the file${end}${green} allPorts${end}\n"
      echo -ne "${green}[+]${end}${gray} Do you want to extract the content? (yes/no)${end}" && read answer
      if [[ "$answer" == "yes" || "$answer" == "y" || "$answer" == "Yes" || "$answer" == "Y" ]]; then
          tput civis
          extractPorts allPorts
          tput cnorm

          echo -ne "\n${green}[+]${end}${gray} Do you want to continue with the Second-stage enumeration step? (yes/no) ${end}" && read secondAnswer
          if [[ "$secondAnswer" == "yes" || "$secondAnswer" == "y" || "$secondAnswer" == "Y" || "$secondAnswer" == "Yes" ]]; then
            continueScanning 
          fi 
      fi 
      else 
        echo -e "\n${red}[!] The response you entered was not valid!${end}"
        exit 1
      fi 
    else # If the host isn't woken up then exit...
      echo -e "\n\n${red}[!] The scan failed! Please, check the host is up or your network connection!${end}\n"
      tput cnorm
      exit 1
    fi 
}
 
function showFlags(){
  echo -e "\n${yellow}[+]${end}${gray} Flags used for the${end}${yellow} quick${end}${gray} scanning: ${end}\n"
  echo -e "\t${blue}-sC${end}${gray}) Executes NSE scripts for default.${end}"
  echo -e "\t${blue}-sV${end}${gray}) Shows the version of the service detected.${end}"
  echo -e "\t${blue}-sS${end}${gray}) Stealth Scan, it executes a quicker and stealther scan.${end}"
  echo -e "\t${blue}-Pn${end}${gray}) It deactivates the Host Discovery.${end}"
  echo -e "\t${blue}--min-rate=5000${end}${gray}) It requests the scanning to send at least 5000 packets per second.${end}" 
  echo -e "\t${blue}-T4${end}${gray}) It sets the speed of the scanning to Agressive.${end}"
  echo -e "\t${blue} -n${end}${gray}) No DNS resolution.${end}"

  echo -e "\n${yellow}[+]${end}${gray} Flags used for the${end}${yellow} slow${end}${gray} scanning: ${end}\n"
  echo -e "\t${blue}-sC${end}${gray}) Executes NSE scripts for default.${end}"
  echo -e "\t${blue}-sV${end}${gray}) Shows the version of the service detected.${end}"
  echo -e "\t${blue}-sS${end}${gray}) Stealth Scan, it executes a quicker and stealther scan.${end}"
  echo -e "\t${blue}--open${end}${gray}) It filters in order to show only the ports that are 'open'.${end}"
  echo -e "\t${blue}-p-${end}${gray}) It scans all the ports (1 - 65535).${end}"
}

function scannIPPorts(){
  machineIP="$1"
  ports="$2"

  echo -e "\n${yellow}[+]${end}${gray} Starting scan for ports${end}${blue} $ports${end}${gray} of the IP${end}${yellow} $machineIP${end}\n"
  tput civis
  sleep 2
  tput cnorm
  # Usage of nmap --> nmap -p "$ports" "$machineIP"
  
  echo -ne "${yellow}[+]${end}${gray} Do you want a quick scan? (Yes/No) ${end}" && read result 

  if [[ "$result" == "yes" || "$result" == "Y" || "$result" == "y" ]]; then

    echo -e "${end}\n${yellow}[+]${end}${gray} Started scanning the IP Address${end}${yellow} $machineIP${end}"
    tput civis
    ping -c 1 -W 5 "$machineIP" > /dev/null 2>&1

    if [ $? -eq 0 ]; then # If the host is woken up then continue...
      tput civis
      nmap -sC -sV --min-rate=5000 -sS -Pn -T4 -n -p "$ports" "$machineIP" -oG allPorts > /dev/null 
      tput cnorm

      echo -e "\n${green}[+]${end}${gray} Scanning finished and saved in the file${end}${green} allPorts${end}\n"
      echo -ne "${green}[+]${end}${gray} Do you want to extract the content? (yes/no) ${end}" && read answer
      if [[ "$answer" == "yes" || "$answer" == "y" || "$answer" == "Yes" || "$answer" == "Y" ]]; then
          tput civis
          extractPorts allPorts
          tput cnorm

          echo -ne "\n${green}[+]${end}${gray} Do you want to continue with the Second-stage enumeration step? (yes/no) ${end}" && read secondAnswer
          if [[ "$secondAnswer" == "yes" || "$secondAnswer" == "y" || "$secondAnswer" == "Y" || "$secondAnswer" == "Yes" ]]; then
            continueScanning 
          fi 
      fi 

    else # If the host isn't woken up then exit... 
      echo -e "\n\n${red}[!] The scan failed! Please, check the host is up or your network connection!${end}\n"
      tput cnorm
      exit 1
    fi 

  elif [[ "$result" == "no" || "$result" == "N" || "$result" == "n" || "$result" == "No" ]]; then 

    echo -e "${end}\n${yellow}[+]${end}${gray} Started scanning the IP Address${end}${yellow} $machineIP${end}"
    tput civis
    ping -c 1 -W 5 "$machineIP" > /dev/null 2>&1

    if [ $? -eq 0 ]; then # If the host is woken up then continue...
      tput civis
      nmap -sC --open -sV -sS -p "$ports" "$machineIP" -oG allPorts > /dev/null 
      tput cnorm

      echo -e "\n${green}[+]${end}${gray} Scanning finished and saved in the file${end}${green} allPorts${end}\n"
      echo -ne "${green}[+]${end}${gray} Do you want to extract the content? (yes/no) ${end}" && read answer
      if [[ "$answer" == "yes" || "$answer" == "y" || "$answer" == "Yes" || "$answer" == "Y" ]]; then
          tput civis
          extractPorts allPorts
          tput cnorm

          echo -ne "\n${green}[+]${end}${gray} Do you want to continue with the Second-stage enumeration step? (yes/no) ${end}" && read secondAnswer
          if [[ "$secondAnswer" == "yes" || "$secondAnswer" == "y" || "$secondAnswer" == "Y" || "$secondAnswer" == "Yes" ]]; then
            continueScanning 
          fi 
      fi 
    else # If the host isn't woken up then exit...
      echo -e "\n\n${red}[!] The scan failed! Please, check the host is up or your network connection!${end}\n"
      tput cnorm
      exit 1
    fi 
  else 
    echo -e "\n${red}[!] The response you entered was not valid!${end}"
    exit 1
  fi 
}

showErrorMessage(){
  echo -e "\n${red}[!] Error: You need to specify the${end}${green} IP Address${end}${red} with the parameter${end}${blue} -i${end}\n"
  tput cnorm
  exit 1
}

# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_ports=0
declare -i chivato_ip=0

while getopts ":i:op:h" arg; do 
  case $arg in 
    i) machineIP=$OPTARG; chivato_ip=1; let parameter_counter+=1;;
    o) let parameter_counter+=2;;
    p) ports=$OPTARG; chivato_ports=1; parameter_counter+=3;;
    h) ;;
    \?) 
      echo -e "\n${red}[!] Invalid option: -$OPTARG${end}"
      exit 1;;
    :)
      echo -e "\n${red}[!] Error: The${end}${blue} -i${end}${red} option requires an${end}${green} IP Address${end}${red}!${end}\n"
      exit 1;;
  esac 
done 

if [ $parameter_counter -eq 1 ]; then
  scanIP $machineIP
elif [ $parameter_counter -eq 2 ]; then
  showFlags 
elif [ $parameter_counter -eq 3 ]; then
  showErrorMessage
elif [ $chivato_ip -eq 1 ] && [ $chivato_ports -eq 1 ]; then
  scannIPPorts $machineIP $ports
else 
  helpPanel
fi 
