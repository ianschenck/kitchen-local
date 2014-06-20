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

        system(provisioner.install_command)
        system(provisioner.init_command)
        transfer_path(sandbox_dirs, provisioner[:root_path])
        system(provisioner.prepare_command)
        system(provisioner.run_command)
      ensure
        provisioner && provisioner.cleanup_sandbox
      end

      def setup(state)
        system(busser_setup_cmd)
      end

      def verify(state)
        system(busser_sync_cmd)
        system(busser_run_cmd)
      end

      def destroy(state) ; end

      def ssh(ssh_args, command)
        system(command)
      end

      protected

      def transfer_path(locals, remote)
        return if locals.nil? || Array(locals).empty?
        locals.each { |local| FileUtils.cp(local, remote) }
      end

    end
  end
end

