Skaner sieciowy podobny do Angry-IP-Scanner. Napisany w skrypcie połoki BASH.

Użycie:

    ./ip_scanner.sh <adres_ip/cidr> [--opcje]

Opcje:

    --calc-only - oblicza na podstawie adresu ip wraz z CIDR adres sieci, adres rozgłoszeniowy, pierwszy i ostatni host w sieci oraz maskę w postaci dzisiętnej.
    --wait-time <czas_w_ms> - określa opcje waittime dla polecenia ping, czyli czas oczekiwania na odpowiedź od hosta.
    --all - Domyślnie podczas skanowania wyświetlane są tylko hosty które odpowiedziały na ping za pomocą tej opcji można wyświetlić dane wszystkich zapytanych hostów.
    --ssh - Wyszukiwanie otwartego portu TCP/22 wśród wyliczonych hostów.

Wartości zwracana:

    Opcja --calc-only:
    +--------------------------------------------------------+
    IP = 192.168.1.0 	 NETMASK = 255.255.255.0
    NET ADDR = 192.168.1.0 	 BCAST ADDR = 192.168.1.255
    HOSTS = 254 		 HOSTNAME = hostname.domain
    FHOST = 192.168.1.1 	 LHOST = 192.168.1.254
    +--------------------------------------------------------+

    Opcja --all:
    +--------------------------------------------------------+
    IP = 192.168.1.0 	 NETMASK = 255.255.255.0
    NET ADDR = 192.168.1.0 	 BCAST ADDR = 192.168.1.255
    HOSTS = 254 		 HOSTNAME = hostname.domain
    FHOST = 192.168.1.1 	 LHOST = 192.168.1.254
    +--------------------------------------------------------+
    [+]	192.168.1.1	 1.327 ms	3(NXDOMAIN)
    [+]	192.168.1.2	 1.186 ms	trash.domain
    [-]	192.168.1.3	 - ms.	3(NXDOMAIN)
    [-]	192.168.1.4	 - ms.	3(NXDOMAIN)
    [-]	192.168.1.5	 - ms.	3(NXDOMAIN)
    [-]	192.168.1.6	 - ms.	3(NXDOMAIN)

    Opcja --ssh:
    +--------------------------------------------------------+
    IP = 192.168.1.0 	 NETMASK = 255.255.255.0
    NET ADDR = 192.168.1.0 	 BCAST ADDR = 192.168.1.255
    HOSTS = 254 		 HOSTNAME = hostname.domain
    FHOST = 192.168.1.1 	 LHOST = 192.168.1.254
    +--------------------------------------------------------+
    [open]	192.168.1.1	3(NXDOMAIN)
    [open]	192.168.1.2	trash.domain
    [closed/filtered]	192.168.1.3	3(NXDOMAIN)
    [closed/filtered]	192.168.1.4	3(NXDOMAIN)
    [closed/filtered]	192.168.1.5	3(NXDOMAIN)

    Bez opcji:
    +--------------------------------------------------------+
    IP = 192.168.1.0 	 NETMASK = 255.255.255.0
    NET ADDR = 192.168.1.0 	 BCAST ADDR = 192.168.1.255
    HOSTS = 254 		 HOSTNAME = hostname.domain
    FHOST = 192.168.1.1 	 LHOST = 192.168.1.254
    +--------------------------------------------------------+
    [+]	192.168.1.1	 1.327 ms	3(NXDOMAIN)
    [+]	192.168.1.2	 1.186 ms	trash.domain

