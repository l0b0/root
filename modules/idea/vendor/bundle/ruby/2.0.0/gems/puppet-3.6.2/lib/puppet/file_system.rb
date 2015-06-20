module Puppet::FileSystem
  require 'puppet/file_system/path_pattern'
  require 'puppet/file_system/file_impl'
  require 'puppet/file_system/memory_file'
  require 'puppet/file_system/memory_impl'
  require 'puppet/file_system/tempfile'

  # create instance of the file system implementation to use for the current platform
  @impl = if RUBY_VERSION =~ /^1\.8/
           require 'puppet/file_system/file18'
           Puppet::FileSystem::File18
         elsif Puppet::Util::Platform.windows?
           require 'puppet/file_system/file19windows'
           Puppet::FileSystem::File19Windows
         else
           require 'puppet/file_system/file19'
           Puppet::FileSystem::File19
         end.new()

  # Allows overriding the filesystem for the duration of the given block.
  # The filesystem will only contain the given file(s).
  #
  # @param files [Puppet::FileSystem::MemoryFile] the files to have available
  #
  # @api private
  #
  def self.overlay(*files, &block)
    old_impl = @impl
    @impl = Puppet::FileSystem::MemoryImpl.new(*files)
    yield
  ensure
    @impl = old_impl
  end

  # Opens the given path with given mode, and options and optionally yields it to the given block.
  #
  # @api public
  #
  def self.open(path, mode, options, &block)
    @impl.open(assert_path(path), mode, options, &block)
  end

  # @return [Object] The directory of this file as an opaque handle
  #
  # @api public
  #
  def self.dir(path)
    @impl.dir(assert_path(path))
  end

  # @return [String] The directory of this file as a String
  #
  # @api public
  #
  def self.dir_string(path)
    @impl.path_string(@impl.dir(assert_path(path)))
  end

  # @return [Boolean] Does the directory of the given path exist?
  def self.dir_exist?(path)
    @impl.exist?(@impl.dir(assert_path(path)))
  end

  # Creates all directories down to (inclusive) the dir of the given path
  def self.dir_mkpath(path)
    @impl.mkpath(@impl.dir(assert_path(path)))
  end

  # @return [Object] the name of the file as a opaque handle
  #
  # @api public
  #
  def self.basename(path)
    @impl.basename(assert_path(path))
  end

  # @return [String] the name of the file
  #
  # @api public
  #
  def self.basename_string(path)
    @impl.path_string(@impl.basename(assert_path(path)))
  end

  # @return [Integer] the size of the file
  #
  # @api public
  #
  def self.size(path)
    @impl.size(assert_path(path))
  end

  # Allows exclusive updates to a file to be made by excluding concurrent
  # access using flock. This means that if the file is on a filesystem that
  # does not support flock, this method will provide no protection.
  #
  # While polling to aquire the lock the process will wait ever increasing
  # amounts of time in order to prevent multiple processes from wasting
  # resources.
  #
  # @param path [Pathname] the path to the file to operate on
  # @param mode [Integer] The mode to apply to the file if it is created
  # @param options [Integer] Extra file operation mode information to use
  #   (defaults to read-only mode)
  # @param timeout [Integer] Number of seconds to wait for the lock (defaults to 300)
  # @yield The file handle, in read-write mode
  # @return [Void]
  # @raise [Timeout::Error] If the timeout is exceeded while waiting to acquire the lock
  #
  # @api public
  #
  def self.exclusive_open(path, mode, options = 'r', timeout = 300, &block)
    @impl.exclusive_open(assert_path(path), mode, options, timeout, &block)
  end

  # Processes each line of the file by yielding it to the given block
  #
  # @api public
  #
  def self.each_line(path, &block)
    @impl.each_line(assert_path(path), &block)
  end

  # @return [String] The contents of the file
  #
  # @api public
  #
  def self.read(path)
    @impl.read(assert_path(path))
  end

  # @return [String] The binary contents of the file
  #
  # @api public
  #
  def self.binread(path)
    @impl.binread(assert_path(path))
  end

  # Determines if a file exists by verifying that the file can be stat'd.
  # Will follow symlinks and verify that the actual target path exists.
  #
  # @return [Boolean] true if the named file exists.
  #
  # @api public
  #
  def self.exist?(path)
    @impl.exist?(assert_path(path))
  end

  # Determines if a file is a directory.
  #
  # @return [Boolean] true if the given file is a directory.
  #
  # @api public
  def self.directory?(path)
    @impl.directory?(assert_path(path))
  end

  # Determines if a file is a file.
  #
  # @return [Boolean] true if the given file is a file.
  #
  # @api public
  def self.file?(path)
    @impl.file?(assert_path(path))
  end

  # Determines if a file is executable.
  #
  # @todo Should this take into account extensions on the windows platform?
  #
  # @return [Boolean] true if this file can be executed
  #
  # @api public
  #
  def self.executable?(path)
    @impl.executable?(assert_path(path))
  end

  # @return [Boolean] Whether the file is writable by the current process
  #
  # @api public
  #
  def self.writable?(path)
    @impl.writable?(assert_path(path))
  end

  # Touches the file. On most systems this updates the mtime of the file.
  #
  # @api public
  #
  def self.touch(path)
    @impl.touch(assert_path(path))
  end

  # Creates directories for all parts of the given path.
  #
  # @api public
  #
  def self.mkpath(path)
    @impl.mkpath(assert_path(path))
  end

  # @return [Array<Object>] references to all of the children of the given
  #   directory path, excluding `.` and `..`.
  # @api public
  def self.children(path)
    @impl.children(assert_path(path))
  end

  # Creates a symbolic link dest which points to the current file.
  # If dest already exists:
  #
  # * and is a file, will raise Errno::EEXIST
  # * and is a directory, will return 0 but perform no action
  # * and is a symlink referencing a file, will raise Errno::EEXIST
  # * and is a symlink referencing a directory, will return 0 but perform no action
  #
  # With the :force option set to true, when dest already exists:
  #
  # * and is a file, will replace the existing file with a symlink (DANGEROUS)
  # * and is a directory, will return 0 but perform no action
  # * and is a symlink referencing a file, will modify the existing symlink
  # * and is a symlink referencing a directory, will return 0 but perform no action
  #
  # @param dest [String] The path to create the new symlink at
  # @param [Hash] options the options to create the symlink with
  # @option options [Boolean] :force overwrite dest
  # @option options [Boolean] :noop do not perform the operation
  # @option options [Boolean] :verbose verbose output
  #
  # @raise [Errno::EEXIST] dest already exists as a file and, :force is not set
  #
  # @return [Integer] 0
  #
  # @api public
  #
  def self.symlink(path, dest, options = {})
    @impl.symlink(assert_path(path), dest, options)
  end

  # @return [Boolean] true if the file is a symbolic link.
  #
  # @api public
  #
  def self.symlink?(path)
    @impl.symlink?(assert_path(path))
  end

  # @return [String] the name of the file referenced by the given link.
  #
  # @api public
  #
  def self.readlink(path)
    @impl.readlink(assert_path(path))
  end

  # Deletes the given paths, returning the number of names passed as arguments.
  # See also Dir::rmdir.
  #
  # @raise an exception on any error.
  #
  # @return [Integer] the number of paths passed as arguments
  #
  # @api public
  #
  def self.unlink(*paths)
    @impl.unlink(*(paths.map {|p| assert_path(p) }))
  end

  # @return [File::Stat] object for the named file.
  #
  # @api public
  #
  def self.stat(path)
    @impl.stat(assert_path(path))
  end

  # @return [Integer] the size of the file
  #
  # @api public
  #
  def self.size(path)
    @impl.size(assert_path(path))
  end

  # @return [File::Stat] Same as stat, but does not follow the last symbolic
  # link. Instead, reports on the link itself.
  #
  # @api public
  #
  def self.lstat(path)
    @impl.lstat(assert_path(path))
  end

  # Compares the contents of this file against the contents of a stream.
  #
  # @param stream [IO] The stream to compare the contents against
  # @return [Boolean] Whether the contents were the same
  #
  # @api public
  #
  def self.compare_stream(path, stream)
    @impl.compare_stream(assert_path(path), stream)
  end

  # Produces an opaque pathname "handle" object representing the given path.
  # Different implementations of the underlying file system may use different runtime
  # objects. The produced "handle" should be used in all other operations
  # that take a "path". No operation should be directly invoked on the returned opaque object
  #
  # @param path [String] The string representation of the path
  # @return [Object] An opaque path handle on which no operations should be directly performed
  #
  # @api public
  #
  def self.pathname(path)
    @impl.pathname(path)
  end

  # Asserts that the given path is of the expected type produced by #pathname
  #
  # @raise [ArgumentError] when path is not of the expected type
  #
  # @api public
  #
  def self.assert_path(path)
    @impl.assert_path(path)
  end

  # Produces a string representation of the opaque path handle.
  #
  # @param path [Object] a path handle produced by {#pathname}
  # @return [String] a string representation of the path
  #
  def self.path_string(path)
    @impl.path_string(path)
  end

  # Create and open a file for write only if it doesn't exist.
  #
  # @see Puppet::FileSystem::open
  #
  # @raise [Errno::EEXIST] path already exists.
  #
  # @api public
  #
  def self.exclusive_create(path, mode, &block)
    @impl.exclusive_create(assert_path(path), mode, &block)
  end

  # Changes permission bits on the named path to the bit pattern represented
  # by mode.
  #
  # @param mode [Integer] The mode to apply to the file if it is created
  # @param path [String] The path to the file, can also accept [PathName]
  #
  # @raise [Errno::ENOENT]: path doesn't exist
  #
  # @api public
  #
  def self.chmod(mode, path)
    @impl.chmod(mode, path)
  end
end
