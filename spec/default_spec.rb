require 'spec_helper'

platform_test_matrix = {
  oracle: {
    docker_dist: 'oraclelinux',
    versions: ['6.5', '7.0']
  },
  redhat: {
    docker_dist: 'centos',
    versions: ['6.5', '7.0']
  },
  centos: {
    docker_dist: 'centos',
    versions: ['6.5', '7.0']
  },
  fedora: {
    docker_dist: 'fedora',
    versions: %w(20 21 22)
  }
}

describe 'yum-docker' do
  platform_test_matrix.each do |platform, v|
    v[:versions].each do |version|
      describe "when on #{platform} #{version}" do
        describe 'by default' do
          let(:chef_run) do
            ChefSpec::SoloRunner.new(platform: platform.to_s, version: version.to_s)
              .converge(described_recipe)
          end

          it 'should create the docker-main repo with default attribs' do
            expect(chef_run).to create_yum_repository('docker-main').with(
              description: 'Docker main Repository',
              baseurl: "https://yum.dockerproject.org/repo/main/#{v[:docker_dist]}/#{version.to_i}",
              enabled: true,
              gpgcheck: true,
              gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Docker'
            )
          end

          it 'should not create the docker-testing repo' do
            expect(chef_run).to_not create_yum_repository('docker-testing')
          end

          it 'should not create the docker-experimental repo' do
            expect(chef_run).to_not create_yum_repository('docker-experimental')
          end
        end

        describe 'when only docker-testing is managed' do
          let(:chef_run) do
            ChefSpec::SoloRunner.new(platform: platform.to_s, version: version.to_s) do |node|
              node.set['yum-docker']['repos']['docker-main']['managed'] = false
              node.set['yum-docker']['repos']['docker-testing']['managed'] = true
              node.set['yum-docker']['repos']['docker-experimental']['managed'] = false
            end.converge(described_recipe)
          end

          it 'should not create the docker-main repo' do
            expect(chef_run).to_not create_yum_repository('docker-main')
          end

          it 'should create the docker-testing repo with default attribs' do
            expect(chef_run).to create_yum_repository('docker-testing').with(
              description: 'Docker testing Repository',
              baseurl:
              "https://yum.dockerproject.org/repo/testing/#{v[:docker_dist]}/#{version.to_i}",
              enabled: true,
              gpgcheck: true,
              gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Docker'
            )
          end

          it 'should not create the docker-experimental repo' do
            expect(chef_run).to_not create_yum_repository('docker-experimental')
          end
        end

        describe 'when only docker-experimental is managed' do
          let(:chef_run) do
            ChefSpec::SoloRunner.new(platform: platform.to_s, version: version.to_s) do |node|
              node.set['yum-docker']['repos']['docker-main']['managed'] = false
              node.set['yum-docker']['repos']['docker-testing']['managed'] = false
              node.set['yum-docker']['repos']['docker-experimental']['managed'] = true
            end.converge(described_recipe)
          end

          it 'should not create the docker-main repo' do
            expect(chef_run).to_not create_yum_repository('docker-main')
          end

          it 'should not create the docker-testing repo' do
            expect(chef_run).to_not create_yum_repository('docker-testing')
          end

          it 'should create the docker-experimental repo with default attribs' do
            expect(chef_run).to create_yum_repository('docker-experimental').with(
              description: 'Docker experimental Repository',
              baseurl:
              "https://yum.dockerproject.org/repo/experimental/#{v[:docker_dist]}/#{version.to_i}",
              enabled: true,
              gpgcheck: true,
              gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Docker'
            )
          end
        end

        describe 'when adding a custom docker repo' do
          let(:chef_run) do
            ChefSpec::SoloRunner.new(platform: platform.to_s, version: version.to_s) do |node|
              node.set['yum-docker']['repos']['docker-new']['managed'] = true
              node.set['yum-docker']['repos']['docker-new']['repositoryid'] = 'docker-new'
              node.set['yum-docker']['repos']['docker-new']['description'] = 'docker New'
              node.set['yum-docker']['repos']['docker-new']['baseurl'] = 'http://path.to.docker'
              node.set['yum-docker']['repos']['docker-new']['enabled'] = true
              node.set['yum-docker']['repos']['docker-new']['gpgcheck'] = true
              node.set['yum-docker']['repos']['docker-new']['gpgkey'] = 'file://path/to/gpg/key'
            end.converge(described_recipe)
          end

          it 'should create the docker-new repo' do
            expect(chef_run).to create_yum_repository('docker-new').with(
              repositoryid: 'docker-new',
              description: 'docker New',
              baseurl: 'http://path.to.docker',
              enabled: true,
              gpgcheck: true,
              gpgkey: 'file://path/to/gpg/key'
            )
          end
        end
      end
    end
  end

  context 'when on an supported platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.0')
        .converge(described_recipe)
    end

    it 'should create the Docker GPG Key' do
      expect(chef_run).to \
        create_cookbook_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-Docker')
        .with(
          source: 'RPM-GPG-KEY-Docker',
          mode: '644',
          owner: 'root',
          group: 'root'
        )
    end
  end

  describe 'when on an unsupported platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.0') do |node|
        node.set['yum-docker']['supported-families']['rhel']['7'] = false
      end.converge(described_recipe)
    end

    it 'should raise an error' do
      expect { chef_run }.to raise_error('rhel/redhat/7.0 is not supported by the default recipe')
    end
  end
end
