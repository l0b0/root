# Defines a connection between a implementation method and the signature that
# the method will handle.
#
# This interface should not be used directly. Instead dispatches should be
# constructed using the DSL defined in {Puppet::Functions}.
#
# @api private
class Puppet::Pops::Functions::Dispatch < Puppet::Pops::Evaluator::CallableSignature
  # @api public
  attr_reader :type
  # TODO: refactor to parameter_names since that makes it API
  attr_reader :param_names
  attr_reader :injections

  # Describes how arguments are woven if there are injections, a regular argument is a given arg index, an array
  # an injection description.
  #
  attr_reader :weaving
  # @api public
  attr_reader :block_name

  # @api private
  def initialize(type, method_name, param_names, block_name, injections, weaving, last_captures)
    @type = type
    @method_name = method_name
    @param_names = param_names || []
    @block_name = block_name
    @injections = injections || []
    @weaving = weaving
    @last_captures = last_captures
  end

  # @api private
  def parameter_names
    @param_names
  end

  # @api private
  def last_captures_rest?
    !! @last_captures
  end

  # @api private
  def invoke(instance, calling_scope, args)
    instance.send(@method_name, *weave(calling_scope, args))
  end

  # @api private
  def weave(scope, args)
    # no need to weave if there are no injections
    if injections.empty?
      args
    else
      injector = Puppet.lookup(:injector)
      weaving.map do |knit|
        if knit.is_a?(Array)
          injection_data = @injections[knit[0]]
          # inject
          if injection_data[3] == :producer
            injector.lookup_producer(scope, injection_data[0], injection_data[2])
          else
            injector.lookup(scope, injection_data[0], injection_data[2])
          end
        else
          # pick that argument
          args[knit]
        end
      end
    end
  end
end
