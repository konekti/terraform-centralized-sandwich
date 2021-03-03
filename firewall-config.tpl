
--------------------------------------------------------------------------
set system host-name ${hostname}
delete interfaces ethernet eth0 address dhcp 
set interfaces ethernet eth0 address ${untrust_ip}/24
set interfaces ethernet eth1 address ${trust_ip}/24
set nat source rule 100 outbound-interface 'eth1'
set nat source rule 100 source address '0.0.0.0/0'
set nat source rule 100 translation address 'masquerade'
set nat destination rule 100 destination address ${untrust_ip}
set nat destination rule 100 inbound-interface 'eth0'
set nat destination rule 100 protocol 'tcp'
set nat destination rule 100 translation address ${alb_ip}
set protocols static route 0.0.0.0/0 next-hop ${untrust_implied_router_ip}
set protocols static route ${app_vpc_cidr} next-hop ${trust_implied_router_ip}
--------------------------------------------------------------------------