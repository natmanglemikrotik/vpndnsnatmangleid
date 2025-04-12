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
    :local hosts {"1.1.1.1"; "1.0.0.1"}
    :local count 10

    :foreach host in=$hosts do={
        :local success 0
        :local totalLatency 0

        :for i from=1 to=$count do={
            :local pingResult [/ping $host count=1]
            :if ($pingResult > 0) do={
                :set success ($success + 1)
                :set totalLatency ($totalLatency + $pingResult)
            }
            :delay 1s
        }

        :if ($success > 0) do={
            :local avgLatency ($totalLatency / $success)
            :log warning ("[===>> Status Ping DNS via VPN] $host: $success/$count reply | Avg Latency: $avgLatency ms")
        } else={
            :log warning ("[===>> Status Ping DNS via VPN] $host GAGAL! Tidak ada reply!")
        }
    }
}

