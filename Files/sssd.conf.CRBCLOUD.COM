[sssd]
domains = crbcloud.com
config_file_version = 2
services = nss, pam

[domain/crbcloud.com]
ad_domain = crbcloud.com
krb5_realm = CRBCLOUD.COM
realmd_tags = manages-system joined-with-samba
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = simple