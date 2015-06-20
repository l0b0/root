# Configuration settings for a single directory Environment.
# @api private
class Puppet::Settings::EnvironmentConf
  VALID_SETTINGS = [:modulepath, :manifest, :config_version, :environment_timeout].freeze

  # Given a path to a directory environment, attempts to load and parse an
  # environment.conf in ini format, and return an EnvironmentConf instance.
  #
  # An environment.conf is optional, so if the file itself is missing, or
  # empty, an EnvironmentConf with default values will be returned.
  #
  # @note logs warnings if the environment.conf contains any ini sections,
  # or has settings other than the three handled for directory environments
  # (:manifest, :modulepath, :config_version)
  #
  # @param path_to_env [String] path to the directory environment
  # @param global_module_path [Array<String>] the installation's base modulepath
  #   setting, appended to default environment modulepaths
  # @return [EnvironmentConf] the parsed EnvironmentConf object
  def self.load_from(path_to_env, global_module_path)
    path_to_env = File.expand_path(path_to_env)
    conf_file = File.join(path_to_env, 'environment.conf')
    config = nil

    begin
      config = Puppet.settings.parse_file(conf_file)
      validate(conf_file, config)
      section = config.sections[:main]
    rescue Errno::ENOENT
      # environment.conf is an optional file
    end

    new(path_to_env, section, global_module_path)
  end

  # Provides a configuration object tied directly to the passed environment.
  # Configuration values are exactly those returned by the environment object,
  # without interpolation.  This is a special case for the default configured
  # environment returned by the Puppet::Environments::StaticPrivate loader.
  def self.static_for(environment)
    Static.new(environment)
  end

  attr_reader :section

  # Create through EnvironmentConf.load_from()
  def initialize(path_to_env, section, global_module_path)
    @path_to_env = path_to_env
    @section = section
    @global_module_path = global_module_path
  end

  def manifest
    get_setting(:manifest, File.join(@path_to_env, "manifests")) do |manifest|
      absolute(manifest)
    end
  end

  def environment_timeout
    # gen env specific config or use the default value
    get_setting(:environment_timeout, Puppet.settings.value(:environment_timeout)) do |ttl|
      # munges the string form statically without really needed the settings system, only
      # its ability to munge "4s, 3m, 5d, and 'unlimited' into seconds - if already munged into
      # numeric form, the TTLSetting handles that.
      Puppet::Settings::TTLSetting.munge(ttl, 'environment_timeout')
    end
  end

  def modulepath
    default_modulepath = [File.join(@path_to_env, "modules")] + @global_module_path
    get_setting(:modulepath, default_modulepath) do |modulepath|
      path = modulepath.kind_of?(String) ?
        modulepath.split(File::PATH_SEPARATOR) :
        modulepath
      path.map { |p| absolute(p) }.join(File::PATH_SEPARATOR)
    end
  end

  def config_version
    get_setting(:config_version) do |config_version|
      absolute(config_version)
    end
  end

  private

  def self.validate(path_to_conf_file, config)
    valid = true
    section_keys = config.sections.keys
    main = config.sections[:main]
    if section_keys.size > 1
      Puppet.warning("Invalid sections in environment.conf at '#{path_to_conf_file}'. Environment conf may not have sections. The following sections are being ignored: '#{(section_keys - [:main]).join(',')}'")
      valid = false
    end

    extraneous_settings = main.settings.map(&:name) - VALID_SETTINGS
    if !extraneous_settings.empty?
      Puppet.warning("Invalid settings in environment.conf at '#{path_to_conf_file}'. The following unknown setting(s) are being ignored: #{extraneous_settings.join(', ')}")
      valid = false
    end

    return valid
  end

  def get_setting(setting_name, default = nil)
    setting = section.setting(setting_name) if section
    value = setting.value if setting
    value ||= default
    yield value
  end

  def absolute(path)
    return nil if path.nil?
    if path =~ /^\$/
      # Path begins with $something interpolatable
      path
    else
      File.expand_path(path, @path_to_env)
    end
  end

  # Models configuration for an environment that is not loaded from a directory.
  #
  # @api private
  class Static
    def initialize(environment)
      @environment = environment
    end

    def manifest
      @environment.manifest
    end

    def modulepath
      @environment.modulepath.join(File::PATH_SEPARATOR)
    end

    def config_version
      @environment.config_version
    end

    def environment_timeout
      0
    end
  end

end
