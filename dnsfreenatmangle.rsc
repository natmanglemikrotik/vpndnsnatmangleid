/interface sstp-client
add comment="Server VPN Natmangle" connect-to=vpn1.natmangle.id:1027 disabled=no http-proxy=0.0.0.0:1027 name="VPN DNS Natmangle ID" password=dnspassnatmangle profile=default-encryption user=dns verify-server-address-from-certificate=no
/ip dns
set allow-remote-requests=yes cache-size=12048KiB max-udp-packet-size=768 servers=1.1.1.1,1.0.0.1
/ip firewall nat
add chain=srcnat out-interface="VPN DNS Natmangle ID" action=masquerade
/ip route
add distance=1 dst-address=1.1.1.1/32 gateway=192.168.255.255
add distance=1 dst-address=1.0.0.1/32 gateway=192.168.255.255
/tool netwatch
add comment="link gateway tunnel VPN Natmangle ID 192.168.255.255" down-script=":log war\
    ning \"link gateway tunnel VPN Natmangle ID 192.168.255.255 is down/rto/intermittent\
    \"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])" host=192.168.255.255 up-script=":log w\
    arning \"link gateway tunnel VPN Natmangle ID 192.168.255.255  is up\"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])"
add comment="VPN serve vpn1.natmangle.id" down-script=":log warning \"link VPN\
    \_vpn2.natmangle.id is down/rto/intermittent\"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])" host=103.43.1.12 up-script=":lo\
    g warning \"link VPN vpn1.natmangle.id  is up\"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])"
