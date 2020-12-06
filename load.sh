#! /bin/bash

CLIENTE="XXX"
TIPO="server"
NAME=$(hostname -s|tr '[:upper:]' '[:lower:]')


start()
{
free -m|grep Mem|awk '{print "mem_total "$2"\nmem_used "$3"\nmem_free "$4"\nmem_shared "$5"\nmem_cache "$6"\nmem_available "$7}'
free -m|grep Swap|awk '{print "swap_total "$2"\nswap_used "$3"\nswap_free "$4}'
echo -n "load "
echo "scale=2; $(uptime|rev |awk '{print $3}'|rev|sed 's/,$//g') / $(nproc)"|tr -s ',' '.'|bc -l| sed 's/^\./0./'
top -b -n 1|egrep "^Cpu|%Cpu" |tr -s '%' ' '|awk '{print "us "$2"\nsy "$4"\nni "$6"\nid "$8"\nwa "$10"\nhi "$12"\nsi "$14"\nst "$16}'
}

start | tr -s ',' '.' | tr '[:upper:]' '[:lower:]'| curl --data-binary @- http://191.252.182.151:9091/metrics/job/${CLIENTE}/TIPO/${TIPO}/NAME/$NAME

