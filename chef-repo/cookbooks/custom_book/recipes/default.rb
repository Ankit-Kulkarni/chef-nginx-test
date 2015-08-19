# Cookbook Name:: custom_book
# Recipe:: default
#
# Copyright 2015 , Ankit Kulkarni

# maintainer       'ankit'
# license          'All rights reserved'
# description      'Installs/Configures a sample  application'
# long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
# version          '0.1.0'

# update the sources
include_recipe 'apt::default'

# update the repository in case of ubuntu
bash 'apt-update' do
  user node['root']['user']
	code <<-EOH
	 apt-get update
	 EOH
end

# ================================= Nginx ==========================================
# delete the default site nginx configuration symlink to avoid nginx start point chaos
file '/etc/nginx/sites-enabled/000-default' do
	owner node['root']['user']
	group node['root']['user']
	action :delete
end

# delete the default site nginx configuration file to avoid nginx start point chaos
file '/etc/nginx/sites-available/default' do
	owner node['root']['user']
	group node['root']['user']
	action :delete
end


# create/check nginx configuration
template "/etc/nginx/conf.d/#{node['nginx_config_name']}.conf"   do
  source "sample_nginx_app.conf.erb"
  owner "#{node['nginx']['user']}"
  group "#{node['nginx']['user']}"
	# chef Config['node_name'] is set to the node name in chef (it needs to be without domain name )
  variables( :DOMAIN_NAME => Chef::Config[:node_name] + node['our_domain'],
             :IP =>  Chef::node["ipaddress"]       )
  mode 0644
  action :create
end

# reload nginx configuration
service "nginx" do
  action :reload
end

# start nginx if not started
service "nginx" do
  action :start
end

#====================================== Netowkr Interfaces===============================
# create/check for network interfaces file
template "/etc/network/interfaces" do
  source "sample_network_interfaces.conf.erb"
  owner "#{node['root']['user']}"
  group "#{node['root']['user']}"
  variables(:IP =>  Chef::node["ipaddress"],
	       :NETWORK => node["network_address"])
  mode 0644
  action :create
end



#============================================ DNSMasq ===================================

# inclding dnsmasq Recipe to install it
include_recipe 'dnsmasq::default'

# start the dnsmasq service if not started
service "dnsmasq" do
  action :start
end

# create/check/configure dnsmasq configuration
template "/etc/dnsmasq.conf" do
  source "sample_dnsmasq.conf.erb"
  owner "#{node['root']['user']}"
  group "#{node['root']['user']}"

  variables( :DOMAIN_NAME => Chef::Config[:node_name] + node['our_domain'],
             :IP =>  Chef::node["ipaddress"]       )
  mode 0644
  action :create
end

# restart the dnsmasq service
service "dnsmasq" do
  action :restart
end
