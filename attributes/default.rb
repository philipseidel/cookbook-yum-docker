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

baseurl_prefix = 'https://yum.dockerproject.org/repo'
baseurl_suffix = "#{docker_dist}/#{node['platform_version'].to_i}"

default['yum-docker']['repos'].tap do |repo|
  repo['docker-main'].tap do |value|
    # Does this cookbook manage the install of the Docker Main Repo?
    value['managed'] = true
    # Unique Name for Docker Main Repo
    value['repositoryid'] = 'docker-main-repo'
    # Description of Docker Main Repo
    value['description'] = 'Docker main Repository'
    # URL of Docker Main Repo
    value['baseurl'] = "#{baseurl_prefix}/main/#{baseurl_suffix}"
    # Whether or not the Docker Main Repo is enabled?
    value['enabled'] = true
    # Whether or not Docker Main Repo should perform GPG check of packages?
    value['gpgcheck'] = true
    # GPG Key of Docker Stable Repo
    value['gpgkey'] = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Docker'
  end

  repo['docker-testing'].tap do |value|
    # Does this cookbook manage the install of the Docker Testing Repo?
    value['managed'] = false
    # Unique Name for Docker Testing Repo
    value['repositoryid'] = 'docker-testing-repo'
    # Description of Docker Testing Repo
    value['description'] = 'Docker testing Repository'
    # URL of Docker Testing Repo
    value['baseurl'] = "#{baseurl_prefix}/testing/#{baseurl_suffix}"
    # Whether or not the Docker Testing Repo is enabled?
    value['enabled'] = true
    # Whether or not Docker Testing Repo should perform GPG check of packages?
    value['gpgcheck'] = true
    # GPG Key of Docker Testing Repo
    value['gpgkey'] = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Docker'
  end

  repo['docker-experimental'].tap do |value|
    # Does this cookbook manage the install of the Docker Experimental Repo?
    value['managed'] = false
    # Unique Name for Docker Experimental Repo
    value['repositoryid'] = 'docker-experimental-repo'
    # Description of Docker Experimental Repo
    value['description'] = 'Docker experimental Repository'
    # URL of Docker Experimental Repo
    value['baseurl'] = "#{baseurl_prefix}/experimental/#{baseurl_suffix}"
    # Whether or not the Docker Experimental Repo is enabled?
    value['enabled'] = true
    # Whether or not Docker Experimental Repo should perform GPG check of
    #  packages?
    value['gpgcheck'] = true
    # GPG Key of Docker Experimental Repo
    value['gpgkey'] = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Docker'
  end
end
