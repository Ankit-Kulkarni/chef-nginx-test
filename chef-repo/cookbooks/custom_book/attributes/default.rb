# default system level root user
default["root"]["user"] = "root"

# default system level user (is added in sudoers )
default["user"] = "ubuntu"

# default nginx user
default["nginx"]["user"] = "www-data"

# default nginx configuration file to be created in /etc/ngnix/conf.d/
default["nginx_config_name"]="home"


# default network to be used
default["network_address"] = "172.31.11.0"

# our default domain name
default["our_domain"] = ".XYZ.com"

# overiding default dns hash from dnsmasq cookbook
default['dnsmasq']['dns'] = {
  'no-poll' => nil,
  'server' => '127.0.0.1'
}
