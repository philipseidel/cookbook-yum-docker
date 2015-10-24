name 'yum-docker'
maintainer 'St. Isidore de Seville'
maintainer_email 'st.isidore.de.seville@gmail.com'
license 'MIT'
description 'Installs/Configures yum Docker Vendor-Specific Repository'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

source_url 'https://github.com/st-isidore-de-seville/cookbook-yum-docker'
issues_url 'https://github.com/st-isidore-de-seville/cookbook-yum-docker/issues'

recipe 'yum-docker::default', 'Installs/Configures yum Docker Vendor-Specific Repository'

depends 'yum', '~> 3.8'

supports 'redhat'
supports 'centos'
supports 'oracle'
supports 'fedora'
