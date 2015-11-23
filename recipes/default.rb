#
# Cookbook Name:: yum-docker
# Recipe:: default
#
#  Installs & configures the yum Docker repostories.  Any attribute supported by
#  the [yum cookbook](https://github.com/chef-cookbooks/yum#parameters) is
#  supported by this cookbook and can be used to override attributes in this
#  cookbook.

# check is platform is supported
platform_family = node['platform_family']
platform = node['platform']
platform_version = node['platform_version']

fail("#{platform_family}/#{platform}/#{platform_version} is not supported by the default recipe") \
 unless node['yum-docker']['supported-families'][platform_family]
        .select { |_version, is_included| is_included }
        .keys
        .include?(platform_version.to_i.to_s)

# install GPG key
cookbook_file '/etc/pki/rpm-gpg/RPM-GPG-KEY-Docker' do
  source 'RPM-GPG-KEY-Docker'
  mode '644'
  owner 'root'
  group 'root'
end

# install repos
node['yum-docker']['repos'].each do |repo, value|
  yum_repository repo do
    # define all attributes even though we are not using them all so that the
    #  values can be passed through to override yum repository definitions

    # Attribute Sources:
    #  https://github.com/chef-cookbooks/yum
    #  https://github.com/chef-cookbooks/yum/blob/master/resources/repository.rb

    baseurl value['baseurl'] unless value['baseurl'].nil?
    cost value['cost'] unless value['cost'].nil?
    description value['description'] unless value['description'].nil?
    enabled value['enabled'] unless value['enabled'].nil?
    enablegroups value['enablegroups'] unless value['enablegroups'].nil?
    exclude value['exclude'] unless value['exclude'].nil?
    failovermethod value['failovermethod'] unless value['failovermethod'].nil?
    fastestmirror_enabled value['fastestmirror_enabled'] unless value['fastestmirror_enabled'].nil?
    gpgcheck value['gpgcheck'] unless value['gpgcheck'].nil?
    gpgkey value['gpgkey'] unless value['gpgkey'].nil?
    http_caching value['http_caching'] unless value['http_caching'].nil?
    includepkgs value['includepkgs'] unless value['includepkgs'].nil?
    keepalive value['keepalive'] unless value['keepalive'].nil?
    make_cache value['make_cache'] unless value['make_cache'].nil?
    max_retries value['max_retries'] unless value['max_retries'].nil?
    metadata_expire value['metadata_expire'] unless value['metadata_expire'].nil?
    mirror_expire value['mirror_expire'] unless value['mirror_expire'].nil?
    mirrorlist value['mirrorlist'] unless value['mirrorlist'].nil?
    mirrorlist_expire value['mirrorlist_expire'] unless value['mirrorlist_expire'].nil?
    mode value['mode'] unless value['mode'].nil?
    options value['options'] unless value['options'].nil?
    password value['password'] unless value['password'].nil?
    priority value['priority'] unless value['priority'].nil?
    proxy value['proxy'] unless value['proxy'].nil?
    proxy_username value['proxy_username'] unless value['proxy_username'].nil?
    proxy_password value['proxy_password'] unless value['proxy_password'].nil?
    report_instanceid value['report_instanceid'] unless value['report_instanceid'].nil?
    repositoryid value['repositoryid'] unless value['repositoryid'].nil?
    skip_if_unavailable value['skip_if_unavailable'] unless value['skip_if_unavailable'].nil?
    source value['source'] unless value['source'].nil?
    sslcacert value['sslcacert'] unless value['sslcacert'].nil?
    sslclientcert value['sslclientcert'] unless value['sslclientcert'].nil?
    sslclientkey value['sslclientkey'] unless value['sslclientkey'].nil?
    sslverify value['sslverify'] unless value['sslverify'].nil?
    timeout value['timeout'] unless value['timeout'].nil?
    username value['username'] unless value['username'].nil?
  end if value['managed']
end
