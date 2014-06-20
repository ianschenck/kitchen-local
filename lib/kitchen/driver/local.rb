require 'fileutils'

require 'kitchen'
require 'kitchen/driver/base'

module Kitchen
  module Driver
    class Local < Base
      
      def create(state) ; end

      def converge(state)
        provisioner = instance.provisioner
        provisioner.create_sandbox
        sandbox_dirs = Dir.glob("#{provisioner.sandbox_path}/*")

        run(provisioner.install_command)
        run(provisioner.init_command)
        transfer_path(sandbox_dirs, provisioner[:root_path])
        provisioner.prepare_command && run(provisioner.prepare_command)
        provisioner.run_command && run(provisioner.run_command)
      ensure
        provisioner && provisioner.cleanup_sandbox
      end

      def setup(state)
        busser_setup_cmd && run(busser_setup_cmd)
      end

      def verify(state)
        busser_sync_cmd && run(busser_sync_cmd)
        busser_run_cmd && run(busser_run_cmd)
      end

      def destroy(state) ; end

      def ssh(ssh_args, command)
        command && run(command)
      end

      protected

      def run(command)
        system({
                 "GEM_PATH" => nil,
                 "GEM_HOME" => nil,
                 "BUNDLE_BIN_PATH" => nil,
                 "BUNDLE_GEMFILE" => nil,
                 "RUBYOPT" => nil,
                 "RUBYLIB" => nil
               },command)
      end

      def transfer_path(locals, remote)
        return if locals.nil? || Array(locals).empty?
        locals.each { |local| `cp -r #{local} #{remote}` }
      end

    end
  end
end

