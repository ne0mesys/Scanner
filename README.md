# 🌐 Scanner.sh by ne0mesys
*This script has been created by ne0mesys and serves as an automation tool for the IP Address and ports scanning, hope you guys like it ;)*

## Welcome

This software serves as an automation tool for the enumeration penetration process. It helps to scan, indicate and show all the relevant information of this step. This bash script allows penetration testers to have a quicker and better structured enumeration step providing information about the ports and IP Address scanning. In order to execute the script **you will need Root privileges!** 

Please! Be careful at the time to input the IP Address of the target, otherwise the script could throw an error. Same for the ports, if you want to input the ports, input them as you do with ***nmap*** --> ***80,443,445***

This tool is developed strictly for educational and ethical purposes. I DO NOT take any responsibility for the misuse of this tool.


By ne0mesys

## Requirements 

### For Linux

*Nmap* is required in order to perform the whole scanning part. In case you don't have it installed, you can find the instructions below for Linux users: 
```
sudo apt update && sudo apt upgrade
sudo apt install nmap
 ```
You will need as well a software that allows you to paste your clipboard with commands,  **xclip**. In case you don't have it installed, you can find the instructions below: 
```
sudo apt install xclip
 ```

**Without this software the script won't work!!**

### For Arch Linux 

*Nmap* is required in order to perform the whole scanning part. In case you don't have it installed, you can find the instructions below for Arch Linux users: 
```
sudo pacman -S nmap
 ```
You will need as well a software that allows you to paste your clipboard with commands,  **xclip**. In case you don't have it installed, you can find the instructions below: 
```
sudo pacman -S xclip
 ```

**Without this software the script won't work!!**

## Installation

### For Linux

Here's a short documentation about how to install the script for Linux users: 
```
sudo apt install git
sudo git clone https://github.com/ne0mesys/Scanner
cd Scanner
 ```

### For Arch Linux

Here's a short documentation about how to install the script for Arch Linux users: 
```
sudo pacman -S git
sudo git clone https://github.com/ne0mesys/Scanner
cd Scanner
 ```

## Execution

Once we are in the same folder of the software, we can proceed to enable its execution. We can do this with the following command:
```
sudo chmod +x scanner.sh
```

The software includes the Shebang line ```#!/usr/bin/bash``` which allows the user to execute it directly. We can do this using the command ```./scanner.sh```. 

However, it would be necessary to have the script **always** in the same directory we are in. Therefore, I highly suggest to move a copy with execution permits to the **$PATH** so we use it as a command:  ```sanner``` 

In order to do this perform the next commands in the terminal: 
```
sudo chmod +x scanner.sh
sudo mv scanner.sh /usr/local/bin/scanner
```
**Now you are able to use the script as a command in the terminal!** 

**Try it with the command** ```scanner```

## About

This tool has been created in order to speed up the enumeration process of a penetration attack. Instead of typing all the commands in the terminal, I have decided to shorten the process with this script. 

This script rather than just allowing to have  the whole enumeration process automated, allows as well to have it in a colorful output that enhances the whole process.

The use of parameters that can be indicated by the user, allows to perform the enumeration step quicker and better structured. This script uses the following tools in order to perform this action: ***ping*** & ***nmap***. It uses as well several customized functions created for this script, such as *extract_ports* & *continueScanning*. 

The **parameters** of this script are the following ones: 
* -i) Indicates the IP Address.
* -p) Indicates the Ports chosen.
* -o) Shows the flags used for each scan.
* -h) Shows the help panel.

## Author:

* Ne0mesys

Feel free to open an Issue...
```
E-Mail at: ne0mesys.acc@gmail.com
```
