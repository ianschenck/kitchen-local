require 'kitchen'
require 'kitchen/transport/base'
require 'fileutils'

module Kitchen
  module Transport
    class Local < Base
      default_config :dry_run, false

      def connection(state, &block)
        options = {
          logger: logger,
          dry_run: config[:dry_run],
        }.merge(state)
        Connection.new(options, &block)
      end

      class Connection < Base::Connection
        def init_options(options)
          super
          @dry_run = !!options.delete(:dry_run)
        end

        def execute(command)
          return if command.nil?
          if @dry_run
            logger.debug("Would execute #{command}")
            return
          end
          logger.debug("Executing #{command}")
          # "jail-break" from bundler
          env = %w[
            GEM_PATH GEM_HOME
            BUNDLE_BIN_PATH BUNDLE_GEMFILE
            RUBYOPT RUBYLIB
          ].inject({}){|out, name| out[name] = nil; out}
          IO.popen(env, command + ' 2>&1') {|f|
            f.each_line do |line|
              logger << line 
            end
          }
          unless $?.success?
            raise TransportFailed, "command exited with #{$?.exitstatus}: #{command.dump}"
          end
        end

        def login_command
          "true"
        end

        def upload(locals, remote)
          Array(locals).each do |local|
            if @dry_run
              logger.debug("Would transfer #{local} => #{remote}")
              return
            end

            logger.debug("Transferring #{local} => #{remote}")
            if File.directory? local
              FileUtils.cp_r local, remote
            else
              FileUtils.cp local, File.join(remote, File.basename(local))
            end
          end
        rescue => ex
          raise TransportFailed, "file copy failed: #{ex.message}"
        end
      end
    end
  end
end
