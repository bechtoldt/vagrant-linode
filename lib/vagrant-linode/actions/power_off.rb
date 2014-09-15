require 'vagrant-linode/helpers/client'
# TODO: --force
module VagrantPlugins
  module Linode
    module Actions
      class PowerOff
        include Helpers::Client

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @client = client
          @logger = Log4r::Logger.new('vagrant::linode::power_off')
        end

        def call(env)
          # submit power off linode request
          result = @client.linode.shutdown(linodeid: @machine.id)

          # wait for request to complete
          env[:ui].info I18n.t('vagrant_linode.info.powering_off')
          wait_for_event(env, result['jobid'])

          # refresh linode state with provider
          Provider.linode(@machine, refresh: true)

          @app.call(env)
        end
      end
    end
  end
end
