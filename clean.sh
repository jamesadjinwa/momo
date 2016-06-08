#!/bin/bash
# tradextractclean.sh
# author : @adjinwa
# purpose : for office ...

# BEGIN

clear

shopt -s -o nounset

declare -rx SCRIPT=${0##*/}

# Sanity checks
if test -z "$BASH" ; then
	printf "$SCRIPT:$LINEO: please run this script with the BASH shell\n" >&2
	exit 192
fi

# CLean the file retailerPaymentDetails.csv
# Format to  
# ---Header---
#,Receipt,Subscriber,Terminal,Date/Time,Sum,Service,Retailer,
# ---
`sed -i.bak -e '/^,*"[0-9,]*",*$/d; 5!{/^#/d}; /Page [0-9]* of/d; s/,,/,/g; s/,$//g; 1,4d' \
	retailerPaymentDetails.csv`

#END
