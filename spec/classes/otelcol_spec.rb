# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:config_dir) do
        case facts[:osfamily]
        when 'windows'
          'C:/Program Files/otelcol'
        else
          '/etc/otelcol'
        end
      end
      let(:main_config) { "#{config_dir}/config.yaml" }

      let(:configcontent) do
        {
          'receivers' => {
            'otlp' => {
              'protocols' => {
                'http' => {},
                'grpc' => {},
              },
            },
          },
          'processors' => {},
          'exporters' => {},
          'extensions' => {},
          'service' => {
            'extensions' => [],
            'pipelines' => {},
          },

        }
      end

      context 'default include'
      it { is_expected.to compile.with_all_deps }
      it {
        is_expected.to contain_class('otelcol::config')
        is_expected.to contain_file('otelcol-config').with_path('/etc/otelcol/config.yaml')
        is_expected.to contain_file('otelcol-environment').with_path('/etc/otelcol/otelcol.conf')
        is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol/config.yaml"})
      }
      it {
        is_expected.to contain_class('otelcol::install')
        is_expected.to contain_package('otelcol').with_ensure('installed')
        is_expected.to contain_package('otelcol').with_name('otelcol')
      }
      it {
        is_expected.to contain_class('otelcol::service')
        is_expected.to contain_service('otelcol').with_ensure('running').with_name('otelcol')
      }
      context 'with package_name to otelcol-contrib' do
        let :params do
          {
            package_name: 'otelcol-contrib',
          }
        end

        it {
          is_expected.to contain_class('otelcol::config')
          is_expected.to contain_file('otelcol-config').with_path('/etc/otelcol-contrib/config.yaml')
          # is_expected.to contain_file('otelcol-config').with_content(%r{"otlp":\s\{\s"protocols":\s\{\s"http":})

          is_expected.to contain_file('otelcol-environment').with_path('/etc/otelcol-contrib/otelcol-contrib.conf')
          is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol-contrib/config.yaml"})
        }
        it { # Validate vaild YAML for config
          is_expected.to contain_file('otelcol-config').with_content(configcontent.to_yaml)
          # yaml_object = YAML.load(catalogue.resource('file', 'otelcol-config').send(:parameters)[:content])
          # expect(yaml_object.length).to be > 0
        }
        it {
          is_expected.to contain_class('otelcol::install')
          is_expected.to contain_package('otelcol').with_ensure('installed')
          is_expected.to contain_package('otelcol').with_name('otelcol-contrib')
          is_expected.to contain_service('otelcol').with_name('otelcol-contrib')
        }

        context 'with manage archive' do
          let :params do
            {
              package_name: 'otelcol-contrib',
              manage_archive: true,
            }
          end

          let(:package_source) do
            case facts[:osfamily]
            when 'Debian'
              'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.77.0/otelcol-contrib_0.77.0_linux_amd64.deb'
            when 'RedHat'
              'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.77.0/otelcol-contrib_0.77.0_linux_amd64.rpm'
            end
          end

          it {
            is_expected.to contain_package('otelcol').with_source("#{package_source}")
          }
        end
      end

      context 'with package_ensure' do
        let :params do
          {
            package_ensure: 'latest',
          }
        end

        it { is_expected.to contain_package('otelcol').with_ensure('latest') }
      end

      context 'with environment_file' do
        let :params do
          {
            environment_file: '/etc/otelcol/env.conf',
          }
        end

        it { is_expected.to contain_file('otelcol-environment').with_path('/etc/otelcol/env.conf') }
      end

      context 'with run_options' do
        let :params do
          {
            run_options: '--debug',
          }
        end

        it { is_expected.to contain_file('otelcol-environment').with_content(%r{--debug}) }
      end

      context 'with config_file' do
        let :params do
          {
            config_file: '/etc/otelcol/test.conf',
          }
        end

        it {
          is_expected.to contain_file('otelcol-config').with_path('/etc/otelcol/test.conf')
          is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol/test.conf"})
        }
      end

      context 'with config_file owner' do
        let :params do
          {
            config_file_owner: 'root',
            config_file_group: 'root',
            config_file_mode: '0600',
          }
        end

        it {
          is_expected.to contain_file('otelcol-config').with(
            'owner' => 'root',
            'group' => 'root',
            'mode'  => '0600',
          )
        }
      end

      context 'with config_file' do
        let :params do
          {
            config_file: '/etc/otelcol/test.conf',
          }
        end

        it {
          is_expected.to contain_file('otelcol-config').with_path('/etc/otelcol/test.conf')
          is_expected.to contain_file('otelcol-environment').with_content(%r{--config=/etc/otelcol/test.conf"})
        }
      end

      context 'with receivers' do
        let :params do
          {
            receivers: {
              'test' => {},
            },
          }
        end
        let(:configcontent_ext) do
          configcontent.merge({ 'receivers' => { 'test' => {} } })
        end

        it { is_expected.to contain_file('otelcol-config').with_content(configcontent_ext.to_yaml) }
      end

      context 'with processors' do
        let :params do
          {
            processors: {
              'test' => {},
            },
          }
        end
        let(:configcontent_ext) do
          configcontent.merge({ 'processors' => { 'test' => {} } })
        end

        it { is_expected.to contain_file('otelcol-config').with_content(configcontent_ext.to_yaml) }
      end

      context 'with exporters' do
        let :params do
          {
            exporters: {
              'test' => {},
            },
          }
        end
        let(:configcontent_ext) do
          configcontent.merge({ 'exporters' => { 'test' => {} } })
        end

        it { is_expected.to contain_file('otelcol-config').with_content(configcontent_ext.to_yaml) }
      end

      context 'with pipelines' do
        let :params do
          {
            pipelines: {
              'test' => {},
            },
          }
        end
        let(:configcontent_ext) do
          configcontent.merge(
            {
              'service' => {
                'extensions' => [],
                'pipelines' => { 'test' => {} }
              },
            },
          )
        end

        it { is_expected.to contain_file('otelcol-config').with_content(configcontent_ext.to_yaml) }
      end

      context 'with extensions' do
        let :params do
          {
            extensions: {
              'test' => {},
            },
          }
        end
        let(:configcontent_ext) do
          configcontent.merge(
            {
              'extensions' => { 'test' => {} },
              'service' => {
                'extensions' => ['test'],
                'pipelines' => {}
              },
            },
          )
        end

        it { is_expected.to contain_file('otelcol-config').with_content(configcontent_ext.to_yaml) }
      end

      context 'with service_ensure' do
        let :params do
          {
            service_ensure: 'stopped',
          }
        end

        it { is_expected.to contain_service('otelcol').with_ensure('stopped') }
      end

      context 'do not manage Service' do
        let :params do
          {
            manage_service: false,
          }
        end

        it { is_expected.not_to contain_class('otelcol::service') }
      end

      context 'manage archive' do
        let :params do
          {
            manage_archive: true,
          }
        end

        let(:package_source) do
          case facts[:osfamily]
          when 'Debian'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.77.0/otelcol_0.77.0_linux_amd64.deb'
          when 'RedHat'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.77.0/otelcol_0.77.0_linux_amd64.rpm'
          end
        end

        it {
          is_expected.to contain_package('otelcol').with_source("#{package_source}")
        }
      end

      context 'manage archive with Version' do
        let :params do
          {
            manage_archive: true,
            archive_version: '0.74.0'
          }
        end

        let(:package_source) do
          case facts[:osfamily]
          when 'Debian'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.74.0/otelcol_0.74.0_linux_amd64.deb'
          when 'RedHat'
            'https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.74.0/otelcol_0.74.0_linux_amd64.rpm'
          end
        end

        it {
          is_expected.to contain_package('otelcol').with_source("#{package_source}")
        }
      end
    end
  end
end
