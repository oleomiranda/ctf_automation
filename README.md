# What is it?
<b> A bash script I created to automate part of my recon when doing CTFs </b>
## What it tests
- Runs nmap on all tcp ports
- Check if it can access FTP and SMP without credentials
- Runs FFUF to find paths and to find subdomains
- Only check for subdomains if a url was passed and not an ip
- Saves the results in different text files 
