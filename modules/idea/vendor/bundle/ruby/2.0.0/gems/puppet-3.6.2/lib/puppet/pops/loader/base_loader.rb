# BaseLoader
# ===
# An abstract implementation of Puppet::Pops::Loader::Loader
#
# A derived class should implement `find(typed_name)` and set entries, and possible handle "miss caching".
#
# @api private
#
class Puppet::Pops::Loader::BaseLoader < Puppet::Pops::Loader::Loader

  # The parent loader
  attr_reader :parent

  # An internal name used for debugging and error message purposes
  attr_reader :loader_name

  def initialize(parent_loader, loader_name)
    @parent = parent_loader # the higher priority loader to consult
    @named_values = {}      # hash name => NamedEntry
    @last_name = nil        # the last name asked for (optimization)
    @last_result = nil      # the value of the last name (optimization)
    @loader_name = loader_name # the name of the loader (not the name-space it is a loader for)
  end

  # @api public
  #
  def load_typed(typed_name)
    # The check for "last queried name" is an optimization when a module searches. First it checks up its parent
    # chain, then itself, and then delegates to modules it depends on.
    # These modules are typically parented by the same
    # loader as the one initiating the search. It is inefficient to again try to search the same loader for
    # the same name.
    if typed_name == @last_name
      @last_result
    else
      @last_name = typed_name
      @last_result = internal_load(typed_name)
    end
  end

  # This method is final (subclasses should not override it)
  #
  # @api private
  #
  def get_entry(typed_name)
    @named_values[typed_name]
  end

  # @api private
  #
  def set_entry(typed_name, value, origin = nil)
    if entry = @named_values[typed_name] then fail_redefined(entry); end
    @named_values[typed_name] = Puppet::Pops::Loader::Loader::NamedEntry.new(typed_name, value, origin)
  end

  # @api private
  #
  def add_entry(type, name, value, origin)
    set_entry(Puppet::Pops::Loader::Loader::TypedName.new(type, name), value, origin)
  end

  # Promotes an already created entry (typically from another loader) to this loader
  #
  # @api private
  #
  def promote_entry(named_entry)
    typed_name = named_entry.typed_name
    if entry = @named_values[typed_name] then fail_redefined(entry); end
    @named_values[typed_name] = named_entry
  end

  private

  def fail_redefine(entry)
    origin_info = entry.origin ? " Originally set at #{origin_label(entry.origin)}." : "unknown location"
    raise ArgumentError, "Attempt to redefine entity '#{entry.typed_name}' originally set at #{origin_label(origin)}.#{origin_info}"
  end

  # TODO: Should not really be here?? - TODO: A Label provider ? semantics for the URI?
  #
  def origin_label(origin)
    if origin && origin.is_a?(URI)
      origin.to_s
    elsif origin.respond_to?(:uri)
      origin.uri.to_s
    else
      nil
    end
  end

  # loads in priority order:
  # 1. already loaded here
  # 2. load from parent
  # 3. find it here
  # 4. give up
  #
  def internal_load(typed_name)
    # avoid calling get_entry, by looking it up
    @named_values[typed_name] || parent.load_typed(typed_name) || find(typed_name)
  end

end
