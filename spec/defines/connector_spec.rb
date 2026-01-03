# frozen_string_literal: true

require 'spec_helper'

describe 'otelcol::connector' do
  let(:title) { 'spanmetrics' }
  let(:params) do
    {
      'config' => {
        'key' => 'value',
      }
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_otelcol__component('spanmetrics-connectors').with({
                                                                                   'order' => 1500,
                                                                                   'config' => {
                                                                                     'key' => 'value',
                                                                                   },
                                                                                   'pipelines' => [],
                                                                                   'type' => 'connectors',
                                                                                   'component_name' => 'spanmetrics',
                                                                                 })
      }

      it {
        is_expected.to contain_concat__fragment('otelcol-config-connectors-spanmetrics').with({
                                                                                                'order' => 1500,
                                                                                                'target' => 'otelcol-config',
                                                                                              })
      }

      context 'with order' do
        let :params do
          super().merge({ 'order' => 1 })
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_otelcol__component('spanmetrics-connectors').with({
                                                                                     'order' => 1501,
                                                                                     'config' => {
                                                                                       'key' => 'value',
                                                                                     },
                                                                                     'pipelines' => [],
                                                                                     'type' => 'connectors',
                                                                                     'component_name' => 'spanmetrics',
                                                                                   })
        }
      end
    end
  end
end
