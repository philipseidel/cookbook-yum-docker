#
# Cookbook Name:: yum-docker
# Attributes:: default
#

if platform_family?('rhel')
  if platform?('oracle')
    # Oracle Linux packaged separately
    docker_dist = 'oraclelinux'
  else
    # all other RHEL platforms
    docker_dist = 'centos'
  end
elsif platform_family?('fedora')
  docker_dist = 'fedora'
end

default['yum-docker']['supported-families'] = {
  fedora: {
    '20' => true,
    '21' => true,
    '22' => true
  },
  rhel: {
    '6' => true,
    '7' => true
  }
}

baseurl_prefix = 'https://yum.dockerproject.org/repo/'
baseurl_suffix = "#{docker_dist}/#{node['platform_version'].to_i}"

default['yum-docker']['repos'].tap do |repo|
  repo['docker-main'].tap do |value|
    value['managed'] = true
    value['repositoryid'] = 'docker-main-repo'
    value['description'] = 'Docker main Repository'
    value['baseurl'] = "#{baseurl_prefix}/main/#{baseurl_suffix}/"
    value['enabled'] = true
    value['gpgcheck'] = true
    value['gpgkey'] = ''
  end

  repo['docker-testing'].tap do |value|
    value['managed'] = false
    value['repositoryid'] = 'docker-testing-repo'
    value['description'] = 'Docker testing Repository'
    value['baseurl'] = "#{baseurl_prefix}/testing/#{baseurl_suffix}/"
    value['enabled'] = true
    value['gpgcheck'] = true
    value['gpgkey'] = ''
  end

  repo['docker-experimental'].tap do |value|
    value['managed'] = false
    value['repositoryid'] = 'docker-experimental-repo'
    value['description'] = 'Docker experimental Repository'
    value['baseurl'] = "#{baseurl_prefix}/testing/#{baseurl_suffix}/"
    value['enabled'] = true
    value['gpgcheck'] = true
    value['gpgkey'] = ''
  end
end
