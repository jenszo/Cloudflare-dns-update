#!/bin/sh

_cf_zone_id=${CF_ZONE_ID?ERROR:Missing zone_id}
_cf_dns_record_id=${CF_DNS_RECORD_ID?ERROR:Missing record_id}
_cfg_dns_domain=${CF_DNS_DOMAIN?ERROR:Missing domain name}
_cf_api_token=${CF_API_TOKEN?ERROR:Missing Cloudflare API TOKEN}
_cf_refresh_cylce=${CF_REFRESH_CYLCE:-5}
_actual_ip=""

while true; do
  #Get the public IP address of the server
  _current_ip=`dig -4 +short myip.opendns.com @resolver1.opendns.com`

  echo -n "Update $_cfg_dns_domain to $_current_ip: "
  [[ "$_actual_ip" != "$_current_ip" ]] && {

    _response=$(curl -s -X PUT https://api.cloudflare.com/client/v4/zones/${_cf_zone_id}/dns_records/${_cf_dns_record_id} -H "Content-Type: application/json" -H "Authorization: Bearer ${_cf_api_token}" -H "cache-control: no-cache" -d "{\"type\" : \"A\", \"name\" : \"${_cfg_dns_domain}\", \"content\" : \"${_current_ip}\", \"proxied\" : \"true\" }")
    _is_updated=$(echo ${_response} | jq --raw-output '.success' )
    _error_msg=$(echo ${_response} | jq --raw-output '.errors[].message')

    #Check if the error message is empty or null and if it is, try and look for a fallback error message
    if [ -z "$_error_msg" ] || [ ! -n "$_error_msg" ]; then
      _error_msg=$(echo ${_response} | jq --raw-output '.errors[].error_chain[].message')
    fi

    [[ $_is_updated == true ]] && { echo "success"; _actual_ip=$_current_ip; } || echo "failed: $_error_msg"

  } || {
    echo "nothing to do..."
  }

  sleep $_cf_refresh_cylce

done
