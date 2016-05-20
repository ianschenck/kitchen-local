require 'fileutils'

require 'kitchen'
require 'kitchen/driver/base'

module Kitchen
  module Driver
    class Local < Base
      def create(state) ; end

      def setup(state)
        busser_setup_cmd && run(busser_setup_cmd)
      end

      def verify(state)
        busser_sync_cmd && run(busser_sync_cmd)
        busser_run_cmd && run(busser_run_cmd)
      end

      def destroy(state) ; end
    end
  end
end

