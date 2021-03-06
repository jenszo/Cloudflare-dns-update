FROM alpine:3.12

RUN apk add jq bind-tools curl

#Store the cloudflare zone ID. Get this information from your cloudflare dashboard
ENV CF_ZONE_ID ""

#Store the DNS Zone record ID
#Get this information from the cloudflare DNS API: https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records
ENV CF_DNS_RECORD_ID ""

#Store the DNS Zone name, e.g. example.net
ENV CF_DNS_DOMAIN ""

#A cloudflare API Token eligible to manipulate DNS settings
#You can create an API token under your account settings
ENV CF_API_TOKEN ""

# The cycle by which to check whether the public IP has changed.
# => eff. the max. downtime of the dynamic host when address changes
ENV CF_REFRESH_CYLCE 60

COPY cf-dns-updater.sh /opt/
CMD ["/opt/cf-dns-updater.sh"]
