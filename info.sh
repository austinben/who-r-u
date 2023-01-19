#!/bin/bash

# SENG460 Lab Assignment - Spring 2022
# Benjamin Austin V00892013

# who doesnt like a bit of ascii? creds to https://patorjk.com/software/taag

# ███████╗███████╗███╗   ██╗ ██████╗     ██╗  ██╗ ██████╗  ██████╗ 
# ██╔════╝██╔════╝████╗  ██║██╔════╝     ██║  ██║██╔════╝ ██╔═████╗
# ███████╗█████╗  ██╔██╗ ██║██║  ███╗    ███████║███████╗ ██║██╔██║
# ╚════██║██╔══╝  ██║╚██╗██║██║   ██║    ╚════██║██╔═══██╗████╔╝██║
# ███████║███████╗██║ ╚████║╚██████╔╝         ██║╚██████╔╝╚██████╔╝
# ╚══════╝╚══════╝╚═╝  ╚═══╝ ╚═════╝          ╚═╝ ╚═════╝  ╚═════╝ 
                                                                 

# --------------------------- constants and setup ---------------------------
# wow pretty colors and text very cool wow
red=$(tput setaf 1)
green=$(tput setaf 2)
magenta=$(tput setaf 5)
bold=$(tput bold)
normal=$(tput sgr0)

# usage text to be printed when incorrect arguments are provided
USAGE="usage: $bold./info.sh$normal, when prompted, provide one of the following: 
        - a domain $green(eg yahoo.com)
        $normal- an email $green(eg bob@yahoo.com)
        $normal- a url $green(eg www.yahoo.com)
        $normal- an ip $green(eg 98.137.11.163)$normal"

# store regex for different input validation
EMAIL_RX="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
IP_RX="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$"

# input type flag: 0 = email, 1 = ip, 2 = url/domain
input_type=-1

# exit if things fail
#set -e
# ---------------------------------------------------------------------------


# --------------------------- input validation and detection ----------------
# make sure we only get a single input to the script
# echo script usage info if incorrect arguments and exit
if [ $# -ne 1 ]; then
  echo "$USAGE" 
  exit
fi

# check if input is valid email addr based on regex
# parse out user@ from email input to provide a clean domain var
if [[ $1 =~ $EMAIL_RX ]]; then
    domain=$(echo "$1" | sed 's/.*@//')
    input_type=0
# check if input is valid IP address based on regex
elif [[ $1 =~ $IP_RX ]]; then
    input_type=2
# otherwise assume its a url/domain
# parse out appended "www."" from url input to provide a clean domain var
else
    domain=$(echo "$1" | sed 's/.*www.//')
    input_type=1
fi
# ---------------------------------------------------------------------------


# --------------------------- main script logic -----------------------------
# email type
if [[ "$input_type" == "0" ]]; then
    echo "$bold======================== collecting information for email address $magenta$1$normal$bold ========================$normal"
    echo
    # run commands and parse them to be less eye melting
    mail_exchanger_section=$(dig $domain MX +short)
    whois_data=$(whois $domain)
    whois_server=$(echo "$whois_data" | grep "Registrar WHOIS Server:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    whois_data=$(whois -h "$whois_server" "$domain")
    domain_id=$(echo "$whois_data" | grep "Registry Domain ID:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    domain_registrar=$(echo "$whois_data" | grep "Registrar:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    registrant_org=$(echo "$whois_data" | grep "Organization:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    registrant_name=$(echo "$whois_data" | grep "Registrant Name:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    abuse_email=$(echo "$whois_data" | grep "Registrar Abuse Contact Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    abuse_phone=$(echo "$whois_data" | grep "Registrar Abuse Contact Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    admin_email=$(echo "$whois_data" | grep "Admin Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    admin_phone=$(echo "$whois_data" | grep "Admin Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tech_email=$(echo "$whois_data" | grep "Tech Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tech_phone=$(echo "$whois_data" | grep "Tech Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    reg_email=$(echo "$whois_data" | grep "Registrant Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    reg_phone=$(echo "$whois_data" | grep "Registrant Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    country=$(echo "$whois_data" | grep "Registrant Country:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    state=$(echo "$whois_data" | grep "Registrant State/Province:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    expiry_date=$(echo "$whois_data" | grep "Registrar Registration Expiration Date:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    if [ -z "$registrant_org" ]; then
        registrant_org="${red}unavailable${normal}"
    fi
    if [ -z "$registrant_name" ]; then
        registrant_name="${red}unavailable${normal}"
    fi
    if [ -z "$abuse_email" ]; then
        abuse_email="${red}unavailable${normal}"
    fi
    if [ -z "$abuse_phone" ]; then
        abuse_phone="${red}unavailable${normal}"
    fi
     if [ -z "$admin_email" ]; then
        admin_email="${red}unavailable${normal}"
    fi
    if [ -z "$admin_phone" ]; then
        admin_phone="${red}unavailable${normal}"
    fi
    if [ -z "$tech_email" ]; then
        tech_email="${red}unavailable${normal}"
    fi
    if [ -z "$tech_phone" ]; then
        tech_phone="${red}unavailable${normal}"
    fi
    if [ -z "$reg_email" ]; then
        reg_email="${red}unavailable${normal}"
    fi
    if [ -z "$reg_phone" ]; then
        reg_phone="${red}unavailable${normal}"
    fi
    if [ -z "$country" ]; then
        country="${red}unavailable${normal}"
    fi
    if [ -z "$state" ]; then
        state="${red}unavailable${normal}"
    fi
    if [ -z "$expiry_date" ]; then
        expiry_date="${red}unavailable${normal}"
    fi

    # output our results for the email addr, just print the mx records and a bit of domain info
    echo "$bold----------- mx records -----------$normal"
    echo "$mail_exchanger_section"
    echo
    echo "$bold----------- domain information -----------$normal"
    echo "domain: ${domain}"
    echo "domain id: ${domain_id}"
    echo "domain registrar: ${domain_registrar}"
    echo "registrar whois server: ${whois_server}"
    echo "registrant organization: ${registrant_org}"
    echo "registrant name: ${registrant_name}"
    echo "registrar abuse contact email: ${abuse_email}"
    echo "registrar abuse contact phone: ${abuse_phone}"
    echo "registrant contact email: ${reg_email}"
    echo "registrant phone: ${reg_phone}"
    echo "admin contact email: ${admin_email}"
    echo "admin phone: ${admin_phone}"
    echo "tech contact email: ${tech_email}"
    echo "tech phone: ${tech_phone}"
    echo "country: ${country}"
    echo "state/province: ${state}"
    echo "registration expiry date: ${expiry_date}"
    echo
fi

# url/domain type
if [[ "$input_type" == "1" ]]; then
    echo "$bold======================== collecting information for domain $magenta$1$normal$bold ========================$normal"
    echo

    # run a quick ping and validate if will resolve
    pingresult=$(ping -c 1 $1 &> /dev/null && echo success || echo fail)
    if [ "$pingresult" != "success" ]; then
        echo "$bold[${red}error${normal}${bold}]$normal the domain $green$bold$1$normal could not be resolved. please try a different domain"
        exit
    fi

    # run commands and parse them to be less eye melting
    whois_data=$(whois $domain)
    whois_server=$(echo "$whois_data" | grep "Registrar WHOIS Server:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    whois_data=$(whois -h "$whois_server" "$domain")
    domain_id=$(echo "$whois_data" | grep "Registry Domain ID:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    domain_registrar=$(echo "$whois_data" | grep "Registrar:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    registrant_org=$(echo "$whois_data" | grep "Organization:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    registrant_name=$(echo "$whois_data" | grep "Registrant Name:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    abuse_email=$(echo "$whois_data" | grep "Registrar Abuse Contact Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    abuse_phone=$(echo "$whois_data" | grep "Registrar Abuse Contact Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    admin_email=$(echo "$whois_data" | grep "Admin Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    admin_phone=$(echo "$whois_data" | grep "Admin Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tech_email=$(echo "$whois_data" | grep "Tech Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tech_phone=$(echo "$whois_data" | grep "Tech Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    reg_email=$(echo "$whois_data" | grep "Registrant Email:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    reg_phone=$(echo "$whois_data" | grep "Registrant Phone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    country=$(echo "$whois_data" | grep "Registrant Country:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    state=$(echo "$whois_data" | grep "Registrant State/Province:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    expiry_date=$(echo "$whois_data" | grep "Registrar Registration Expiration Date:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    dig_dns_section=$(dig +noall +answer $1)
    dig_ns_section=$(dig $1 +short NS)
    dig_txt_section=$(dig txt $1 +short)

    if [ -z "$registrant_org" ]; then
        registrant_org="${red}unavailable${normal}"
    fi
    if [ -z "$registrant_name" ]; then
        registrant_name="${red}unavailable${normal}"
    fi
    if [ -z "$abuse_email" ]; then
        abuse_email="${red}unavailable${normal}"
    fi
    if [ -z "$abuse_phone" ]; then
        abuse_phone="${red}unavailable${normal}"
    fi
     if [ -z "$admin_email" ]; then
        admin_email="${red}unavailable${normal}"
    fi
    if [ -z "$admin_phone" ]; then
        admin_phone="${red}unavailable${normal}"
    fi
    if [ -z "$tech_email" ]; then
        tech_email="${red}unavailable${normal}"
    fi
    if [ -z "$tech_phone" ]; then
        tech_phone="${red}unavailable${normal}"
    fi
    if [ -z "$reg_email" ]; then
        reg_email="${red}unavailable${normal}"
    fi
    if [ -z "$reg_phone" ]; then
        reg_phone="${red}unavailable${normal}"
    fi
    if [ -z "$country" ]; then
        country="${red}unavailable${normal}"
    fi
    if [ -z "$state" ]; then
        state="${red}unavailable${normal}"
    fi
    if [ -z "$expiry_date" ]; then
        expiry_date="${red}unavailable${normal}"
    fi


    if [ -z "$dig_dns_section" ]; then
        dig_dns_section="${red} unavailable${normal}"
    fi
    if [ -z "$dig_ns_section" ]; then
        dig_ns_section="${red} unavailable${normal}"
    fi
    if [ -z "$dig_txt_section" ]; then
        dig_txt_section="${red} unavailable${normal}"
    fi

    # output our results for the domain, print domain info, nameservers, dns records, and txt records
    echo "$bold----------- domain information -----------$normal"
    echo "domain: ${domain}"
    echo "domain id: ${domain_id}"
    echo "domain registrar: ${domain_registrar}"
    echo "registrar whois server: ${whois_server}"
    echo "registrant organization: ${registrant_org}"
    echo "registrant name: ${registrant_name}"
    echo "registrar abuse contact email: ${abuse_email}"
    echo "registrar abuse contact phone: ${abuse_phone}"
    echo "registrant contact email: ${reg_email}"
    echo "registrant phone: ${reg_phone}"
    echo "admin contact email: ${admin_email}"
    echo "admin phone: ${admin_phone}"
    echo "tech contact email: ${tech_email}"
    echo "tech phone: ${tech_phone}"
    echo "country: ${country}"
    echo "state/province: ${state}"
    echo "registration expiry date: ${expiry_date}"
    echo
    echo "$bold----------- name servers -----------$normal"
    echo "$dig_ns_section"
    echo
    echo "$bold----------- dns records -----------$normal"
    echo "$dig_dns_section"
    echo
    echo "$bold----------- txt records -----------$normal"
    echo "$dig_txt_section"
    echo
fi

# ip type
if [[ "$input_type" == "2" ]]; then
    echo "$bold======================== collecting information for ip address $magenta$1$normal$bold ========================$normal"
    echo

    # run a quick ping and validate if will resolve
    pingresult=$(ping -c 1 $1 &> /dev/null && echo success || echo fail)
    if [ "$pingresult" != "success" ]; then
        echo "$bold[${red}error${normal}${bold}]$normal the ip address $green$bold$1$normal could not be resolved. please try a different ip address"
        exit
    fi
    
    # run commands and parse them to be less eye melting
    reverse_dns=$(dig -x $1 +short)

    if [ -z "$reverse_dns" ]; then
        reverse_dns="${red} unavailable${normal}"
    fi

    whois_data=$(whois $1)
    cidr=$(echo "$whois_data" | grep "CIDR:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    org=$(echo "$whois_data" | grep "Organization:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    reg_date=$(echo "$whois_data" | grep "RegDate:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    updated_date=$(echo "$whois_data" | grep "Updated:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    country=$(echo "$whois_data" | grep "Country:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    state=$(echo "$whois_data" | grep "StateProv:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    city=$(echo "$whois_data" | grep "City:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    abuse_email=$(echo "$whois_data" | grep "OrgAbuseEmail:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    abuse_phone=$(echo "$whois_data" | grep "OrgAbusePhone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    routing_email=$(echo "$whois_data" | grep "OrgRoutingEmail:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    routing_phone=$(echo "$whois_data" | grep "OrgRoutingPhone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tech_email=$(echo "$whois_data" | grep "OrgTechEmail:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    tech_phone=$(echo "$whois_data" | grep "OrgTechPhone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    noc_email=$(echo "$whois_data" | grep "OrgNOCEmail:" -m 1 | cut -d ":" -f 2,3 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    noc_phone=$(echo "$whois_data" | grep "OrgNOCPhone:" -m 1 | cut -d ":" -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    if [ -z "$registrant_org" ]; then
        registrant_org="${red}unavailable${normal}"
    fi
    if [ -z "$country" ]; then
        country="${red}unavailable${normal}"
    fi
    if [ -z "$state" ]; then
        state="${red}unavailable${normal}"
    fi
    if [ -z "$city" ]; then
        city="${red}unavailable${normal}"
    fi
    if [ -z "$expiry_date" ]; then
        expiry_date="${red}unavailable${normal}"
    fi
    if [ -z "$reverse_dns" ]; then
        reverse_dns="${red}unavailable${normal}"
    fi
    if [ -z "$cidr" ]; then
        cidr="${red}unavailable${normal}"
    fi
    if [ -z "$org" ]; then
        org="${red}unavailable${normal}"
    fi
    if [ -z "$reg_date" ]; then
        reg_date="${red}unavailable${normal}"
    fi
    if [ -z "$updated_date" ]; then
        updated_date="${red}unavailable${normal}"
    fi
    if [ -z "$abuse_email" ]; then
        abuse_email="${red}unavailable${normal}"
    fi
    if [ -z "$abuse_phone" ]; then
        abuse_phone="${red}unavailable${normal}"
    fi
     if [ -z "$routing_email" ]; then
        routing_email="${red}unavailable${normal}"
    fi
    if [ -z "$routing_phone" ]; then
        routing_phone="${red}unavailable${normal}"
    fi
    if [ -z "$tech_email" ]; then
        tech_email="${red}unavailable${normal}"
    fi
    if [ -z "$tech_phone" ]; then
        tech_phone="${red}unavailable${normal}"
    fi
    if [ -z "$noc_email" ]; then
        noc_email="${red}unavailable${normal}"
    fi
    if [ -z "$noc_phone" ]; then
        noc_phone="${red}unavailable${normal}"
    fi


    echo "$bold----------- ip information -----------$normal"
    echo "reverse dns: ${reverse_dns}"
    echo "cidr: ${cidr}"
    echo "organization: ${org}"
    echo "abuse contact email: ${abuse_email}"
    echo "abuse contact phone: ${abuse_phone}"
    echo "routing contact email: ${routing_email}"
    echo "routing phone: ${routing_phone}"
    echo "network operations center contact email: ${noc_email}"
    echo "network operations center phone: ${noc_phone}"
    echo "tech contact email: ${tech_email}"
    echo "tech phone: ${tech_phone}"
    echo "registration date: ${reg_date}"
    echo "last updated date: ${updated_date}"
    echo
    echo "$bold----------- ip location -----------$normal"
    echo "country: ${country}"
    echo "state/province: ${state}"
    echo "city: ${city}"
    echo

fi
# ---------------------------------------------------------------------------
