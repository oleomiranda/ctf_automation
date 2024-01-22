#!/bin/bash

domain=$1
subdomain_wlist=/usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
path_wlist=/usr/share/wordlists/SecLists/Discovery/Web-Content/dirsearch.txt

call_nmap(){
  echo "[+] running nmap"
  nmap -sS -sV -Pn -p- $domain > $domain"_nmap.txt"
}

check_ftp(){

user="anonymous"
password=""
ftp $domain <<END_SCRIPT > $domain"_ftp.txt"

quote USER $user
quote PASS $password 
ls 
quit
END_SCRIPT
}

check_smb(){
  smbclient -L \\\\$domain\\ -U "" --no-pass > $domain"_smb.txt"
  
  if [ $? -eq 1 ]; then
    echo "can't connect to smbclient" > $domain"_smb.txt"
  fi
}

call_ffuf_sub(){
  echo "[+] running fuff for subdomains"
  ffuf -u http://$domain -H "HOST: FUZZ.$domain" -w $subdomain_wlist -fs 300-399  > $domain"_subs.txt"

  if [ $? -eq 1 ]; then
    echo "Some error occurred while trying to find subs" > $domain"_subs.txt"
  fi

}

call_ffuf_path(){
  echo "[+] running fuff for paths"
  ffuf -u http://$domain/FUZZ -w $path_wlist > $domain"_path.txt" 
  if [ $? -eq 1 ]; then
    echo "Some error occurred while trying to find paths" > $domain"_path.txt"
  fi
}


check_ftp
check_smb
call_nmap
call_ffuf_path

if [[ $domain =~ [a-zA-Z] ]]; then 
  call_ffuf_sub
fi

