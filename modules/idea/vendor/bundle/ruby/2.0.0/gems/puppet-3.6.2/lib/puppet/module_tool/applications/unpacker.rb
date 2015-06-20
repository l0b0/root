require 'pathname'
require 'tmpdir'
require 'json'

module Puppet::ModuleTool
  module Applications
    class Unpacker < Application
      def self.unpack(filename, target)
        app = self.new(filename, :target_dir => target)
        app.unpack
        app.move_into(target)
      end

      def self.harmonize_ownership(source, target)
        unless Puppet.features.microsoft_windows?
          source = Pathname.new(source) unless source.respond_to?(:stat)
          target = Pathname.new(target) unless target.respond_to?(:stat)

          FileUtils.chown_R(source.stat.uid, source.stat.gid, target)
        end
      end

      def initialize(filename, options = {})
        @filename = Pathname.new(filename)
        super(options)
        @module_path = Pathname(options[:target_dir])
      end

      def run
        unpack
        module_dir = @module_path + module_name
        move_into(module_dir)

        # Return the Pathname object representing the directory where the
        # module release archive was unpacked the to.
        return module_dir
      end

      # @api private
      def unpack
        begin
          Puppet::ModuleTool::Tar.instance.unpack(@filename.to_s, tmpdir, [@module_path.stat.uid, @module_path.stat.gid].join(':'))
        rescue Puppet::ExecutionFailure => e
          raise RuntimeError, "Could not extract contents of module archive: #{e.message}"
        end
      end

      # @api private
      def root_dir
        return @root_dir if @root_dir

        # Grab the first directory containing a metadata.json file
        metadata_file = Dir["#{tmpdir}/**/metadata.json"].sort_by(&:length)[0]

        if metadata_file
          @root_dir = Pathname.new(metadata_file).dirname
        else
          raise "No valid metadata.json found!"
        end
      end

      # @api private
      def module_name
        metadata = JSON.parse((root_dir + 'metadata.json').read)
        name = metadata['name'][/-(.*)/, 1]
      end

      # @api private
      def move_into(dir)
        dir = Pathname.new(dir)
        dir.rmtree if dir.exist?
        FileUtils.mv(root_dir, dir)
      ensure
        FileUtils.rmtree(tmpdir)
      end

      # Obtain a suitable temporary path for unpacking tarballs
      #
      # @api private
      # @return [String] path to temporary unpacking location
      def tmpdir
        @dir ||= Dir.mktmpdir('tmp-unpacker', Puppet::Forge::Cache.base_path)
      end
    end
  end
end
