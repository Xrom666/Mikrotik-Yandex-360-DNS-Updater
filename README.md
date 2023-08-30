# Mikrotik-Yandex-360-DNS-Updater
Mikrotik script to automatically update the DNS records of the Yandex 360 service.

How to use

1. Get access to Yandex 360 API using this documentation https://yandex.ru/dev/api360/doc/concepts/access.html
2. Create new mikrotik script using WinBox tool, go to: System -> Scripts [Add] and paste script source from this repo.
3. Fill in variable values:

interfaceName

If you want to get the current address from the router's interface, then put the interface name into interfaceName variable in script, for example :local interfaceName "pppoe-out1". Otherwise, the script will try to get the address using external services.

organizationId

Your organization ID (I'll describe how to get it later)

domainName

Your domain name

dnsId

DNS record ID (I'll describe how to get it later)

name

Name of DNS record (@ - for root)

ttl (optional)

TTL for DNS record in seconds

tokenOAuth

Token obtained from step 1.

4. (optional) Create scheduled task. WinBox: System -> Scheduler [Add]
   
   On Event: /system script run <Script_name_created_in_step2>



If you love this project, please consider giving me a ⭐
