# Helper module that makes creation of type objects simpler.
# @api public
#
module Puppet::Pops::Types::TypeFactory
  @type_calculator = Puppet::Pops::Types::TypeCalculator.new()

  Types = Puppet::Pops::Types

  # Produces the Integer type
  # @api public
  #
  def self.integer()
    Types::PIntegerType.new()
  end

  # Produces an Integer range type
  # @api public
  #
  def self.range(from, to)
    t = Types::PIntegerType.new()
    t.from = from unless (from == :default || from == 'default')
    t.to = to unless (to == :default || to == 'default')
    t
  end

  # Produces a Float range type
  # @api public
  #
  def self.float_range(from, to)
    t = Types::PFloatType.new()
    t.from = Float(from) unless from == :default || from.nil?
    t.to = Float(to) unless to == :default || to.nil?
    t
  end

  # Produces the Float type
  # @api public
  #
  def self.float()
    Types::PFloatType.new()
  end

  # Produces the Numeric type
  # @api public
  #
  def self.numeric()
    Types::PNumericType.new()
  end

  # Produces a string representation of the type
  # @api public
  #
  def self.label(t)
    @type_calculator.string(t)
  end

  # Produces the String type, optionally with specific string values
  # @api public
  #
  def self.string(*values)
    t = Types::PStringType.new()
    values.each {|v| t.addValues(v) }
    t
  end

  # Produces the Optional type, i.e. a short hand for Variant[T, Undef]
  def self.optional(optional_type = nil)
    t = Types::POptionalType.new
    t.optional_type = type_of(optional_type)
    t
  end

  # Convenience method to produce an Optional[Object] type
  def self.optional_object()
    optional(object())
  end

  # Produces the Enum type, optionally with specific string values
  # @api public
  #
  def self.enum(*values)
    t = Types::PEnumType.new()
    values.each {|v| t.addValues(v) }
    t
  end

  # Produces the Variant type, optionally with the "one of" types
  # @api public
  #
  def self.variant(*types)
    t = Types::PVariantType.new()
    types.each {|v| t.addTypes(type_of(v)) }
    t
  end

  # Produces the Struct type, either a non parameterized instance representing all structs (i.e. all hashes)
  # or a hash with a given set of keys of String type (names), bound to a value of a given type. Type may be
  # a Ruby Class, a Puppet Type, or an instance from which the type is inferred.
  #
  def self.struct(name_type_hash = {})
    t = Types::PStructType.new
    name_type_hash.map do |name, type|
      elem = Types::PStructElement.new
      if name.is_a?(String) && name.empty?
        raise ArgumentError, "An empty String can not be used where a String[1, default] is expected"
      end
      elem.name = name
      elem.type = type_of(type)
      elem
    end.each {|elem| t.addElements(elem) }
    t
  end

  def self.tuple(*types)
    t = Types::PTupleType.new
    types.each {|elem| t.addTypes(type_of(elem)) }
    t
  end

  # Produces the Boolean type
  # @api public
  #
  def self.boolean()
    Types::PBooleanType.new()
  end

  # Produces the Object type
  # @api public
  #
  def self.object()
    Types::PObjectType.new()
  end

  # Produces the Regexp type
  # @param pattern [Regexp, String, nil] (nil) The regular expression object or a regexp source string, or nil for bare type
  # @api public
  #
  def self.regexp(pattern = nil)
    t = Types::PRegexpType.new()
    if pattern
      t.pattern = pattern.is_a?(Regexp) ? pattern.inspect[1..-2] : pattern
    end
    t.regexp() unless pattern.nil? # compile pattern to catch errors
    t
  end

  def self.pattern(*regular_expressions)
    t = Types::PPatternType.new()
    regular_expressions.each do |re|
      case re
      when String
        re_T = Types::PRegexpType.new()
        re_T.pattern = re
        re_T.regexp()  # compile it to catch errors
        t.addPatterns(re_T)

      when Regexp
        re_T = Types::PRegexpType.new()
        # Regep.to_s includes options user did not enter and does not escape source
        # to work either as a string or as a // regexp. The inspect method does a better
        # job, but includes the //
        re_T.pattern = re.inspect[1..-2]
        t.addPatterns(re_T)

      when Types::PRegexpType
        t.addPatterns(re.copy)

      when Types::PPatternType
        re.patterns.each do |p|
          t.addPatterns(p.copy)
        end

     else
       raise ArgumentError, "Only String, Regexp, Pattern-Type, and Regexp-Type are allowed: got '#{re.class}"
      end
    end
    t
  end

  # Produces the Literal type
  # @api public
  #
  def self.scalar()
    Types::PScalarType.new()
  end

  # Produces a CallableType matching all callables
  # @api public
  #
  def self.all_callables()
    return Puppet::Pops::Types::PCallableType.new
  end

  # Produces a Callable type with one signature without support for a block
  # Use #with_block, or #with_optional_block to add a block to the callable
  # If no parameters are given, the Callable will describe a signature
  # that does not accept parameters. To create a Callable that matches all callables
  # use {#all_callables}.
  #
  # The params is a list of types, where the three last entries may be
  # optionally followed by min, max count, and a Callable which is taken as the block_type.
  # If neither min or max are specified the parameters must match exactly.
  # A min < params.size means that the difference are optional.
  # If max > params.size means that the last type repeats.
  # if max is :default, the max value is unbound (infinity).
  # 
  # Params are given as a sequence of arguments to {#type_of}.
  #
  def self.callable(*params)
    case params.last
    when Types::PCallableType
      last_callable = true
    when Types::POptionalType
      last_callable = true if params.last.optional_type.is_a?(Types::PCallableType)
    end
    block_t = last_callable ? params.pop : nil

    # compute a size_type for the signature based on the two last parameters
    if is_range_parameter?(params[-2]) && is_range_parameter?(params[-1])
      size_type = range(params[-2], params[-1])
      params = params[0, params.size - 2]
    elsif is_range_parameter?(params[-1])
      size_type = range(params[-1], :default)
      params = params[0, params.size - 1]
    end

    types = params.map {|p| type_of(p) }

    # create a signature
    callable_t = Types::PCallableType.new()
    tuple_t = tuple(*types)
    tuple_t.size_type = size_type unless size_type.nil?
    callable_t.param_types = tuple_t

    callable_t.block_type = block_t
    callable_t
  end

  def self.with_block(callable, *block_params)
    callable.block_type = callable(*block_params)
    callable
  end

  def self.with_optional_block(callable, *block_params)
    callable.block_type = optional(callable(*block_params))
    callable
  end

  # Produces the abstract type Collection
  # @api public
  #
  def self.collection()
    Types::PCollectionType.new()
  end

  # Produces the Data type
  # @api public
  #
  def self.data()
    Types::PDataType.new()
  end

  # Creates an instance of the Undef type
  # @api public
  def self.undef()
    Types::PNilType.new()
  end

  # Produces an instance of the abstract type PCatalogEntryType
  def self.catalog_entry()
    Types::PCatalogEntryType.new()
  end

  # Produces a PResourceType with a String type_name
  # A PResourceType with a nil or empty name is compatible with any other PResourceType.
  # A PResourceType with a given name is only compatible with a PResourceType with the same name.
  # (There is no resource-type subtyping in Puppet (yet)).
  #
  def self.resource(type_name = nil, title = nil)
    type = Types::PResourceType.new()
    type_name = type_name.type_name if type_name.is_a?(Types::PResourceType)
    type.type_name = type_name.downcase unless type_name.nil?
    type.title = title
    type
  end

  # Produces PHostClassType with a string class_name.
  # A PHostClassType with nil or empty name is compatible with any other PHostClassType.
  # A PHostClassType with a given name is only compatible with a PHostClassType with the same name.
  #
  def self.host_class(class_name = nil)
    type = Types::PHostClassType.new()
    unless class_name.nil?
      type.class_name = class_name.sub(/^::/, '')
    end
    type
  end

  # Produces a type for Array[o] where o is either a type, or an instance for which a type is inferred.
  # @api public
  #
  def self.array_of(o)
    type = Types::PArrayType.new()
    type.element_type = type_of(o)
    type
  end

  # Produces a type for Hash[Scalar, o] where o is either a type, or an instance for which a type is inferred.
  # @api public
  #
  def self.hash_of(value, key = scalar())
    type = Types::PHashType.new()
    type.key_type = type_of(key)
    type.element_type = type_of(value)
    type
  end

  # Produces a type for Array[Data]
  # @api public
  #
  def self.array_of_data()
    type = Types::PArrayType.new()
    type.element_type = data()
    type
  end

  # Produces a type for Hash[Scalar, Data]
  # @api public
  #
  def self.hash_of_data()
    type = Types::PHashType.new()
    type.key_type = scalar()
    type.element_type = data()
    type
  end

  # Produces a type for Type[T]
  # @api public
  #
  def self.type_type(inst_type = nil)
    type = Types::PType.new()
    type.type = inst_type
    type
  end

  # Produce a type corresponding to the class of given unless given is a String, Class or a PAbstractType.
  # When a String is given this is taken as a classname.
  #
  def self.type_of(o)
    if o.is_a?(Class)
      @type_calculator.type(o)
    elsif o.is_a?(Types::PAbstractType)
      o
    elsif o.is_a?(String)
      type = Types::PRubyType.new()
      type.ruby_class = o
      type
    else
      @type_calculator.infer_generic(o)
    end
  end

  # Produces a type for a class or infers a type for something that is not a class
  # @note
  #   To get the type for the class' class use `TypeCalculator.infer(c)`
  #
  # @overload ruby(o)
  #   @param o [Class] produces the type corresponding to the class (e.g. Integer becomes PIntegerType)
  # @overload ruby(o)
  #   @param o [Object] produces the type corresponding to the instance class (e.g. 3 becomes PIntegerType)
  #
  # @api public
  #
  def self.ruby(o)
    if o.is_a?(Class)
      @type_calculator.type(o)
    else
      type = Types::PRubyType.new()
      type.ruby_class = o.class.name
      type
    end
  end

  # Generic creator of a RubyType - allows creating the Ruby type with nil name, or String name.
  # Also see ruby(o) which performs inference, or mapps a Ruby Class to its name.
  #
  def self.ruby_type(class_name = nil)
    type = Types::PRubyType.new()
    type.ruby_class = class_name
    type
  end

  # Sets the accepted size range of a collection if something other than the default 0 to Infinity
  # is wanted. The semantics for from/to are the same as for #range
  #
  def self.constrain_size(collection_t, from, to)
    collection_t.size_type = range(from, to)
    collection_t
  end

  # Returns true if the given type t is of valid range parameter type (integer or literal default).
  def self.is_range_parameter?(t)
    t.is_a?(Integer) || t == 'default' || t == :default
  end

end
