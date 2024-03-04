#!/bin/bash
# Author                    : Christo Deale
# Date	                    : 2024-03-05
# rhel9_subscription-manager: Utility to Register System & assign Role, SLA & Usage

# ANSI color codes
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}Welcome to RHEL9 Subscription Manager${NC}"

while true; do
    echo -e "${RED}Options:${NC}"
    echo -e "${RED}1.${NC} List current Subscriptions"
    echo -e "${RED}2.${NC} Clean / Unregister Subscription"
    echo -e "${RED}3.${NC} Register Subscription"
    echo -e "${RED}4.${NC} Attach Subscriptions"
    echo -e "${RED}5.${NC} Register for Insights"
    echo -e "${RED}6.${NC} Exit"

    read -p "Enter your choice (1-6): " choice

    case $choice in
        1)
            echo -e "${RED}Listing current Subscriptions...${NC}"
            subscription-manager list --available
            ;;
        2)
            echo -e "${RED}Cleaning / Unregistering Subscription...${NC}"
            subscription-manager remove --all
            subscription-manager unregister
            subscription-manager clean
            ;;
        3)
            echo -e "${RED}Registering Subscription...${NC}"
            read -p "Enter RedHat Username: " username
            read -sp "Enter RedHat Password: " password
            echo -e "\n"
            subscription-manager register --username "$username" --password "$password"

            echo -e "${RED}Choose System Purpose Role:${NC}"
            select role in "Red Hat Enterprise Linux Server" "Red Hat Enterprise Linux Workstation" "Red Hat Enterprise Linux Compute Node"; do
                subscription-manager syspurpose role --set="$role"
                break
            done

            echo -e "${RED}Choose System Purpose SLA:${NC}"
            select sla in "Premium" "Standard" "Self-Support"; do
                subscription-manager syspurpose service-level --set="$sla"
                break
            done

            echo -e "${RED}Choose System Purpose Usage:${NC}"
            select usage in "Production" "Development/Test" "Disaster Recovery"; do
                subscription-manager syspurpose usage --set="$usage"
                break
            done
            ;;
        4)
            echo -e "${RED}Attaching Subscriptions...${NC}"
            subscription-manager attach
            ;;
        5)
            echo -e "${RED}Registering for Insights...${NC}"
            insights-client --register
            ;;
        6)
            echo -e "${RED}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please enter a number between 1 and 6.${NC}"
            ;;
    esac
done

