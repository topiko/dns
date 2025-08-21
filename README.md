
Create a [porkbun](https://porkbun.com/account/domainsSpeedy) domain.

Create the dns subdomains(?) first there, you have `ml`, and `lefthand`.

The `dns.sh SUBDOMAIN` updates the dns service(?).

Remeber to add `dns.sh` into you crontab so that the records keep updating.

You need a `keys.sh` to store the secretive stuff...

```
API_KEY=<pk1_youkey>
API_SECRET=<sk1_yoursecret>
DOMAIN=<your-domain>
```

