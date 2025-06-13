# Scanner.sh by ne0mesys
*This script has been created by ne0mesys and serves as an automation tool for the IP Address and ports scanning, hope you guys like it ;)*

## Welcome

This software serves as an automation tool for the enumeration penetration process. It helps to scan, indicate and show all the relevant information of this step. This bash script allows penetration testers to have a quicker and better structured enumeration step that helps providing information about the ports and IP Address scanning. In order to execute the script **you will need Root privileges!** 

Please! Be careful at the time to input the IP Address of the target, otherwise the script could throw an error. Same for the ports, if you want to input the ports, do it as when you do it with ***nmap*** --> 80,443,445

Thanks for using this tool and I hope you guys like it ;) 

By ne0mesys

## About

This tool uses different parameters that can be indicated by the user allowing the software to perform the enumeration step of a penetration testing quicker and better structured. This script uses the following tools in order to perform this action: ***ping*** & ***nmap***. It uses as well several customized functions created for this script, such as *extract_ports* & *continueScanning*.  

## Requirements 

**Nmap** is required in order to perform the whole scanning part. In case you don't have it installed, you can find the instructions below: 
```
sudo apt update && sudo apt upgrade
sudo apt install nmap
 ```
You will need as well a software that allows you to paste your clipboard with commands,  **xclip**. In case you don't have it installed, you can find the instructions below: 
```
sudo apt install xclip
 ```

## Installation

Here's a short documentation about how to install the script: 
```
sudo apt install git
sudo git clone https://github.com/ne0mesys/Scanner.sh
cd Scanner.sh
 ```
