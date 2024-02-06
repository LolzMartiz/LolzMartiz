

# Hi there 👋, I'm Martiz - An Aspiring Cybersecurity Researcher

I am a cybersecurity enthusiast with a passion for finding vulnerabilities and automation. Successfully completed my Bachelor's, I further developed my skills with hands-on experience in web app testing, bug bounties, and security research. 

As a self-driven learner, I created this automated subdomain discovery script to practice my skills and contribute back to the community. Feel free to connect with me to discuss cybersecurity or opportunities!

📫 How to reach me: lolzmartiz@gmail.com

## Subdomain Discovery Automation Script

This subdomain_scraping.sh script allows automated subdomain discovery and asset tracking for a target organization. 

### How It Works

- It fetches subdomains from BufferOver API and processes them to output a consolidated list of unique subdomains found.  
- Simply update the script with your BufferOver API key and input a file containing root domains to scan.
- The final output file contains all unique subdomains discovered during the automated process.

### Usage

- Configure your BufferOver API key in the fetch_bufferover function
- Input root domains in domain_list.txt (example included) 
- Run: `./subdomain_scraping.sh`
- Final output with all found subdomains is saved in all_unique_subdomains.txt
- Remove other temporary output files: `rm ip_addresses_* && rm unique_subdomains_*`

This script demonstrates my skills in automation, API integration, and output parsing/processing - allowing easy subdomain discovery at scale. It can be customized and integrated into any security workflow.

Let me know if you have any other questions!
