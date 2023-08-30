# Author:  Andrey Gudkovskiy
# Website: https://github.com/Xrom666

:log warning message="YandexDNS. Update starts"
:local interfaceName ""
:local organizationId "PUT_HERE"
:local domainName "PUT_HERE"
:local dnsId "PUT_HERE"
:local name "@"
:local ttl "3600"
:local type "A"
:local tokenOAuth "PUT_HERE"

# Online services which respond with your IPv4, two for redundancy
:local ipDetectService1 "https://api.ipify.org/"
:local ipDetectService2 "https://ipv4.icanhazip.com/"

:local previousIP
:local currentIP

# Resolve current  ip address
:do {:set previousIP [:resolve $domainName]} on-error={ :log warning "YandexDNS. Could not resolve dns name $domainName" };

if ([:len $interfaceName] = 0 ) do= {
	# Detect our public IP adress using special services
	:do {:set currentIP ([/tool fetch url=$ipDetectService1 output=user as-value]->"data")} on-error={
		:log error "YandexDNS. Service does not work: $ipDetectService1"
		#Second try in case the first one is failed
		:do {:set currentIP ([/tool fetch url=$ipDetectService2 output=user as-value]->"data")} on-error={
			:log error "YandexDNS. Service does not work: $ipDetectService2"
		};
	};
} else={
  	:set currentIP [ :tostr [ /ip address get [/ip address find interface=$interfaceName] address ] ];
  	:set currentIP [ :pick $currentIP 0 [ :find $currentIP "/" ] ];
 	:if ([ :len $currentIP ] = 0 ) do= {
    		:log info "YandexDNS. No IP address is assigned to the interface '$interfaceName'.";
    		:error "YandexDNS. No IP address is assigned to the interface '$interfaceName'.";
  	}
}	
:log info "YandexDNS. DNS IP ($previousIP), current internet IP ($currentIP)"

:if ([:tostr $currentIP] != [:tostr $previousIP]) do={
	:log info "YandexDNS. Current IP $currentIP is not equal to previous IP, update needed for $domainName"
	:local yandexPostUrl "https://api360.yandex.net/directory/v1/org/$organizationId/domains/$domainName/dns/$dnsId"
	:log info "YandexDNS. Using POST request: $yandexPostUrl"
	:local yandexResponse
	:do {:set yandexResponse ([/tool fetch http-method=post mode=https http-header-field="Content-Type: application/json, Authorization: OAuth $tokenOAuth" http-data="{\"address\":\"$currentIP\",\"name\":\"$name\",\"ttl\":\"$ttl\",\"type\":\"$type\"}" url=$yandexPostUrl output=user as-value]->"data")}  on-error={
		:log error "YandexDNS. could not send POST request to the Yandex server."
	}
	:log info "YandexDNS. server answer is: $yandexResponse"
} else={
	:log info "YandexDNS. Previous IP ($previousIP) is equal to current IP ($currentIP), no need to update"
}

:log warning message="YandexDNS. Update finished"
