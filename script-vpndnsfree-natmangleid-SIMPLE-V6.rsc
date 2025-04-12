/interface sstp-client
add comment="Server VPN DNS NatmangleID" connect-to=vpndns.natmangle.id:1027 disabled=no http-proxy=0.0.0.0:1027 name="VPN DNS Natmangle ID" password=dnspassnatmangle profile=default-encryption user=dns verify-server-address-from-certificate=no

/ip dns
set allow-remote-requests=yes cache-size=12048KiB max-udp-packet-size=768 servers=1.1.1.1,1.0.0.1

/ip firewall nat
add chain=srcnat out-interface="VPN DNS Natmangle ID" action=masquerade comment="NAT | VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=53 comment="DMZ | UDP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=tcp to-port=53 comment="DMZ | TCP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=5353 comment="DMZ | UDP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=tcp to-port=5353 comment="DMZ | TCP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=udp to-port=853 comment="DMZ | UDP VPN DNS Natmangle"
add action=redirect chain=dstnat port=53 protocol=tcp to-port=853 comment="DMZ | TCP VPN DNS Natmangle"

/ip route
add gateway=192.168.255.255 dst-address=1.0.0.1/32 comment="ROUTING TO VPN DNS Natmangle"
add gateway=192.168.255.255 dst-address=1.1.1.1/32 comment="ROUTING TO VPN DNS Natmangle"

/tool netwatch
add comment="link gateway tunnel VPN Natmangle ID 192.168.255.255" down-script=":log war\
    ning \"link gateway tunnel VPN Natmangle ID 192.168.255.255 is down/rto/intermittent\
    \"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])" host=192.168.255.255 up-script=":log w\
    arning \"link gateway tunnel VPN Natmangle ID 192.168.255.255  is up\"\r\
    \n:local jam ([/system clock get time])\r\
    \n:local tgl ([/system clock get date])"
	
/system scheduler add name="PingDNSVPN_Scheduler" interval=1h start-time=startup comment="Monitoring Ping VPN DNS Setiap 1 Jam Sekali"  on-event={
:local addre1 1.1.1.1;  # DNS Primary
:local addre2 1.0.0.1;  # DNS Secondary
:local ms 19;           # Threshold RTT
:local avgRtt1;
:local avgRtt2;
:local sent1;
:local sent2;
:local received1;
:local received2;

/tool flood-ping $addre1 count=10 do={
  :set sent1 $sent
  :set received1 $received
  :if ($sent = 10 and $received = 10) do={
    :set avgRtt1 $"avg-rtt"
  }
}

:tool flood-ping $addre2 count=10 do={
  :set sent2 $sent
  :set received2 $received
  :if ($sent = 10 and $received = 10) do={
    :set avgRtt2 $"avg-rtt"
  }
}

# Logging untuk DNS Primary (1.1.1.1)
:if ($received1 = 10) do={
  /log warning message="[===>> Status Ping DNS via VPN] $addre1: 10/10 reply | Avg Latency: $avgRtt1 ms"
} else={
  /log warning message="[===>> Status Ping DNS via VPN] $addre1 GAGAL! Tidak ada reply!"
}

# Logging untuk DNS Secondary (1.0.0.1)
:if ($received2 = 10) do={
  /log warning message="[===>> Status Ping DNS via VPN] $addre2: 10/10 reply | Avg Latency: $avgRtt2 ms"
} else={
  /log warning message="[===>> Status Ping DNS via VPN] $addre2 GAGAL! Tidak ada reply!"
}

