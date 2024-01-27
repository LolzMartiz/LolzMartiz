#!/bin/bash

all_unique_subdomains=""

while read -r domain_name; do
    echo "Processing domain: $domain_name"

# Function to fetch subdomains from RapidDNS
fetch_rapiddns() {
    url="https://rapiddns.io/subdomain/$1?full=1#result"
    html=$(curl -s "$url")
    if [[ -n "$html" ]]; then
        domain_names=$(echo "$html" | grep -Eo "[a-zA-Z0-9.-]+\.$1")
        echo "$domain_names"
    else
        echo "Failed to fetch RapidDNS content."
    fi
}

# Function to fetch information from ThreatCrowd API
fetch_threatcrowd() {
    threatcrowd_output=$(curl -s "http://api.threatcrowd.org/searchApi/v2/domain/report/?domain=$1")
    response_code=$(echo "$threatcrowd_output" | jq -r '.response_code')

    if [[ "$response_code" == "1" ]]; then
        echo "$threatcrowd_output" | jq -r '.resolutions[] | .ip_address, .domain' | sort -u
        echo "$threatcrowd_output" | jq -r '.subdomains[]' | sort -u
    elif [[ "$response_code" == "0" ]]; then
        echo "No data available from ThreatCrowd API for domain: $1"
    else
        echo "Unknown response_code from ThreatCrowd API: $response_code"
    fi
}

# Function to fetch information from BufferOver TLS API
fetch_bufferover() {
    bufferover_output=$(curl -s "https://tls.bufferover.run/dns?q=.$1" -H 'x-api-key: MbPgEgnp8M90J94Ucr4gN9zm5OdftJTurevnoir')
    grep -Po '([0-9]{1,3}\.){3}[0-9]{1,3}|[\w.-]+\.\w+' <<< "$bufferover_output" | sort -u
}

# Function to fetch information from Anubis Subdomains API
fetch_anubis() {
    anubis_output=$(curl -s "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u)
    grep -Po '([0-9]{1,3}\.){3}[0-9]{1,3}|[\w.-]+\.\w+' <<< "$anubis_output" | sort -u
}

# Run functions to fetch subdomains from different sources
rapiddns_subdomains=$(fetch_rapiddns "$domain_name")
threatcrowd_subdomains=$(fetch_threatcrowd "$domain_name")
bufferover_subdomains=$(fetch_bufferover "$domain_name")
anubis_subdomains=$(fetch_anubis "$domain_name")

# Combine and display unique subdomains
all_subdomains="$rapiddns_subdomains\n$threatcrowd_subdomains\n$bufferover_subdomains\n$anubis_subdomains"
unique_subdomains=$(echo -e "$all_subdomains" | sort -u)

# Extract IP addresses from the subdomains
ip_addresses=$(echo -e "$unique_subdomains" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

# Save IP addresses to a text file
ip_file="ip_addresses_$domain_name.txt"
echo "$ip_addresses" > "$ip_file"
echo "IP addresses saved to '$ip_file'."

# Save unique subdomains to a text file
subdomains_file="unique_subdomains_$domain_name.txt"
echo "$unique_subdomains" | grep -Eo '([a-zA-Z0-9.-]+\.'"$domain_name"')' | sed 's/\.$//' > "$subdomains_file"
echo "Unique subdomains saved to '$subdomains_file'."

    # Append the unique subdomains to the all_unique_subdomains variable
    all_unique_subdomains+="$unique_subdomains\n"

    echo "Finished processing domain: $domain_name"
    echo "-----------------------------------------"
done < domain_list.txt

# Save all unique subdomains to a single file
all_unique_file="all_unique_subdomains.txt"
echo -e "$all_unique_subdomains" | grep -Eo '([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})' | sort -u > "$all_unique_file"
echo "All unique subdomains saved to '$all_unique_file'."
