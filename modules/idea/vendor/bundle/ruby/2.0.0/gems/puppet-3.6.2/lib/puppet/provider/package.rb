class Puppet::Provider::Package < Puppet::Provider
  # Prefetch our package list, yo.
  def self.prefetch(packages)
    instances.each do |prov|
      if pkg = packages[prov.name]
        pkg.provider = prov
      end
    end
  end

  # Clear out the cached values.
  def flush
    @property_hash.clear
  end

  # Look up the current status.
  def properties
    if @property_hash.empty?
      @property_hash = query || {:ensure => :absent}
      @property_hash[:ensure] = :absent if @property_hash.empty?
    end
    @property_hash.dup
  end

  def validate_source(value)
    true
  end

  # Turns a array of options into flags to be passed to a command.
  # The options can be passed as a string or hash. Note that passing a hash
  # should only be used in case --foo=bar must be passed,
  # which can be accomplished with:
  #     install_options => [ { '--foo' => 'bar' } ]
  # Regular flags like '--foo' must be passed as a string.
  # @param options [Array]
  # @return Concatenated list of options
  # @api private
  def join_options(options)
    return unless options

    options.collect do |val|
      case val
        when Hash
          val.keys.sort.collect do |k|
            "#{k}=#{val[k]}"
          end
        else
          val
      end
    end.flatten
  end
end
