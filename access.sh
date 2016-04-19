#!/usr/bin/env bash

# author      Victor Magarlamov
# email       victor.magarlamov@gmail.com
# homepage    https://github.com/victor-magarlamov/nginx_log_analyzer
# description analysis of access logs for a given day
# version     0.0.1

# ======================================================================
# DAY - day for which you want to display a report
# ======================================================================

DAY='19/Apr/2016'

# ======================================================================
# Variables and Helpers 
# ======================================================================

FILES=log/*.access.*

COUNT_PER_SEC='count_per_sec.tmp'
COUNT_BY_CODE='count_by_code.tmp'
REQUEST_BY_FREQUENCY='request_by_frequency.tmp'
REFERER_BY_FREQUENCY='referer_by_frequency.tmp'

GREEN='\e[32m'
WHITE='\e[0m'
NORMAL='\E(B\E[m'
BOLD='\E[1m'

separator() {
  printf "\n${GREEN}"
  printf "%0.s=" {1..50}
  printf "\n${WHITE}"
}

# ======================================================================
# map()
# ======================================================================

map() {
  find . -name '*.tmp' -type f -delete
  
  for file in $FILES; do
    awk -v patt="$DAY" '($4$5 ~ patt)' $file >> total.tmp
  done

  awk '{print $4$5}' total.tmp | sort | uniq -c | sort -rn -o $COUNT_PER_SEC &
  awk '{print $9}' total.tmp | sort | uniq -c | sort -rn -o $COUNT_BY_CODE &
  awk '{ ind = match($6$7, /\?/)
         if (ind > 0)
           print substr($6$7, 0, ind)
         else
           print $6$7
       }' total.tmp | sort | uniq -c | sort -rn -o $REQUEST_BY_FREQUENCY &
  awk '{ ind = match($11, /\w\//)
         if (ind > 0) 
           print substr($11, 0, ind)
         else
           print $11
       }' total.tmp | sort | uniq -c | sort -rn -o $REFERER_BY_FREQUENCY
  wait
}

# ======================================================================
# reduce()
# ======================================================================

reduce() {
  case "$1" in
    'average' )
      str='Average of requests per second'
      res=$(awk '{s += $1} END {print s/NR}' $COUNT_PER_SEC) 
      ;;
    'max' )
      str='Max of requests per second'
      res=$(awk 'NR == 1 {print $1}' $COUNT_PER_SEC)
      ;;
    'code' )
      str='Codes'
      res=$(awk '{print $2, $1}' $COUNT_BY_CODE)
      ;;
    'request' )
      str='Top of Requests'
      res=$(awk 'FNR <= 5 {print $1, $2}' $REQUEST_BY_FREQUENCY)
      ;;
    'referer' )
      str='Top of Referers'
      res=$(awk 'FNR <= 10 {print $1, $2}' $REFERER_BY_FREQUENCY)
      ;;
  esac
  printf "${BOLD}${GREEN}%s :\n${WHITE}${NORMAL}%s" "$str" "$res"
  separator
}

map && separator && reduce 'average' && reduce 'max' && reduce 'code' && reduce 'request' && reduce 'referer'
