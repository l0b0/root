require 'puppet/pops'
require 'puppet/pops/evaluator/evaluator_impl'

require File.join(File.dirname(__FILE__), '/../factory_rspec_helper')

module EvaluatorRspecHelper
  include FactoryRspecHelper

  # Evaluate a Factory wrapper round a model object in top scope + named scope
  # Optionally pass two or three model objects (typically blocks) to be executed
  # in top scope, named scope, and then top scope again. If a named_scope is used, it must
  # be preceded by the name of the scope.
  # The optional block is executed before the result of the last specified model object
  # is evaluated. This block gets the top scope as an argument. The intent is to pass
  # a block that asserts the state of the top scope after the operations.
  #
  def evaluate in_top_scope, scopename="x", in_named_scope = nil, in_top_scope_again = nil, &block
    node = Puppet::Node.new('localhost')
    compiler = Puppet::Parser::Compiler.new(node)

    # Compiler must create the top scope
#    compiler.send(:evaluate_main)

    # compiler creates the top scope if one is not present
    top_scope = compiler.topscope()
    # top_scope = Puppet::Parser::Scope.new(compiler)

    evaluator = Puppet::Pops::Evaluator::EvaluatorImpl.new
    result = evaluator.evaluate(in_top_scope.current, top_scope)
    if in_named_scope
      other_scope = Puppet::Parser::Scope.new(compiler)
      other_scope.add_namespace(scopename)
      result = evaluator.evaluate(in_named_scope.current, other_scope)
    end
    if in_top_scope_again
      result = evaluator.evaluate(in_top_scope_again.current, top_scope)
    end
    if block_given?
      block.call(top_scope)
    end
    result
  end

  # Evaluate a Factory wrapper round a model object in top scope + local scope
  # Optionally pass two or three model objects (typically blocks) to be executed
  # in top scope, local scope, and then top scope again
  # The optional block is executed before the result of the last specified model object
  # is evaluated. This block gets the top scope as an argument. The intent is to pass
  # a block that asserts the state of the top scope after the operations.
  #
  def evaluate_l in_top_scope, in_local_scope = nil, in_top_scope_again = nil, &block
    node = Puppet::Node.new('localhost')
    compiler = Puppet::Parser::Compiler.new(node)

    # compiler creates the top scope if one is not present
    top_scope = compiler.topscope()

    evaluator = Puppet::Pops::Evaluator::EvaluatorImpl.new
    result = evaluator.evaluate(in_top_scope.current, top_scope)
    if in_local_scope
      # This is really bad in 3.x scope
      elevel = top_scope.ephemeral_level
      top_scope.new_ephemeral(true)
      result = evaluator.evaluate(in_local_scope.current, top_scope)
      top_scope.unset_ephemeral_var(elevel)
    end
    if in_top_scope_again
      result = evaluator.evaluate(in_top_scope_again.current, top_scope)
    end
    if block_given?
      block.call(top_scope)
    end
    result
  end
end
