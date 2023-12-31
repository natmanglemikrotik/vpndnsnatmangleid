/interface sstp-client
add comment="Server VPN Natmangle" connect-to=vpndns.natmangle.id:1027 disabled=no http-proxy=0.0.0.0:1027 name="VPN DNS Natmangle ID" password=dnspassnatmangle profile=default-encryption user=dns verify-server-address-from-certificate=no
/ip dns
set allow-remote-requests=yes cache-size=12048KiB max-udp-packet-size=768 servers=1.1.1.1,1.0.0.1
/ip firewall nat
add chain=srcnat out-interface="VPN DNS Natmangle ID" action=masquerade comment="NAT | VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=53 comment="DMZ | UDP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=tcp to-port=53 comment="DMZ | TCP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=5353 comment="DMZ | TCP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=tcp to-port=5353 comment="DMZ | TCP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=853 comment="DMZ | TCP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=853 comment="DMZ | TCP VPN DNS Natmangle"
/ip route
add gateway=192.168.255.255 dst-address=94.140.14.14/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=94.140.15.15/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=94.140.14.140/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=94.140.15.16/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=94.140.14.15/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=94.140.14.141/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=1.0.0.1/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=1.0.0.2/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=1.0.0.3/32 comment="ROUTING TO VPN DNS Natmangle
add gateway=192.168.255.255 dst-address=1.1.1.1/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=1.1.1.2/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=1.1.1.3/32 comment="ROUTING TO VPN DNS Natmangle"
/tool netwatch
add comment="link gateway tunnel VPN Natmangle ID 192.168.255.255" down-script=":log war\
    ning \"link gateway tunnel VPN Natmangle ID 192.168.255.255 is down/rto/intermittent\
    \"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])" host=192.168.255.255 up-script=":log w\
    arning \"link gateway tunnel VPN Natmangle ID 192.168.255.255  is up\"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])"

