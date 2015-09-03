require 'spec_helper'

# docker package should be installed when a repository is enabled
describe package('docker-engine') do
  it { should be_installed }
end

# docker package should be installed from the docker-experimental repo
describe command('repoquery -i docker-engine') do
  its(:stdout) { should contain('Repository  : docker-experimental') }
end
