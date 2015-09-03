#
# Cookbook Name:: yum-docker
# Recipe:: default
#

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

    baseurl value['baseurl']
    cost value['cost']
    description value['description']
    enabled value['enabled']
    enablegroups value['enablegroups']
    exclude value['exclude']
    failovermethod value['failovermethod']
    fastestmirror_enabled value['fastestmirror_enabled']
    gpgcheck value['gpgcheck']
    gpgkey value['gpgkey']
    http_caching value['http_caching']
    includepkgs value['includepkgs']
    keepalive value['keepalive']
    make_cache value['make_cache']
    max_retries value['max_retries']
    metadata_expire value['metadata_expire']
    mirror_expire value['mirror_expire']
    mirrorlist value['mirrorlist']
    mirrorlist_expire value['mirrorlist_expire']
    mode value['mode']
    options value['options']
    password value['password']
    priority value['priority']
    proxy value['proxy']
    proxy_username value['proxy_username']
    proxy_password value['proxy_password']
    report_instanceid value['report_instanceid']
    repositoryid value['repositoryid']
    skip_if_unavailable value['skip_if_unavailable']
    source value['source']
    sslcacert value['sslcacert']
    sslclientcert value['sslclientcert']
    sslclientkey value['sslclientkey']
    sslverify value['sslverify']
    timeout value['timeout']
    username value['username']
  end if value['managed']
end
