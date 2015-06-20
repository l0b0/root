#
# The Puppet Pops Metamodel
#
# This module contains a formal description of the Puppet Pops (*P*uppet *OP*eration instruction*S*).
# It describes a Metamodel containing DSL instructions, a description of PuppetType and related
# classes needed to evaluate puppet logic.
# The metamodel resembles the existing AST model, but it is a semantic model of instructions and
# the types that they operate on rather than an Abstract Syntax Tree, although closely related.
#
# The metamodel is anemic (has no behavior) except basic datatype and type
# assertions and reference/containment assertions.
# The metamodel is also a generalized description of the Puppet DSL to enable the
# same metamodel to be used to express Puppet DSL models (instances) with different semantics as
# the language evolves.
#
# The metamodel is concretized by a validator for a particular version of
# the Puppet DSL language.
#
# This metamodel is expressed using RGen.
#

require 'rgen/metamodel_builder'

module Puppet::Pops::Model
  extend RGen::MetamodelBuilder::ModuleExtension

  # A base class for modeled objects that makes them Visitable, and Adaptable.
  #
  class PopsObject < RGen::MetamodelBuilder::MMBase
    include Puppet::Pops::Visitable
    include Puppet::Pops::Adaptable
    include Puppet::Pops::Containment
    abstract
  end

  # A Positioned object has an offset measured in an opaque unit (representing characters) from the start
  # of a source text (starting
  # from 0), and a length measured in the same opaque unit. The resolution of the opaque unit requires the
  # aid of a Locator instance that knows about the measure. This information is stored in the model's
  # root node - a Program.
  #
  # The offset and length are optional if the source of the model is not from parsed text.
  #
  class Positioned < PopsObject
    abstract
    has_attr 'offset', Integer
    has_attr 'length', Integer
  end

  # @abstract base class for expressions
  class Expression < Positioned
    abstract
  end

  # A Nop - the "no op" expression.
  # @note not really needed since the evaluator can evaluate nil with the meaning of NoOp
  # @todo deprecate? May be useful if there is the need to differentiate between nil and Nop when transforming model.
  #
  class Nop < Expression
  end

  # A binary expression is abstract and has a left and a right expression. The order of evaluation
  # and semantics are determined by the concrete subclass.
  #
  class BinaryExpression < Expression
    abstract
    #
    # @!attribute [rw] left_expr
    #   @return [Expression]
    contains_one_uni 'left_expr', Expression, :lowerBound => 1
    contains_one_uni 'right_expr', Expression, :lowerBound => 1
  end

  # An unary expression is abstract and contains one expression. The semantics are determined by
  # a concrete subclass.
  #
  class UnaryExpression < Expression
    abstract
    contains_one_uni 'expr', Expression, :lowerBound => 1
  end

  # A class that simply evaluates to the contained expression.
  # It is of value in order to preserve user entered parentheses in transformations, and
  # transformations from model to source.
  #
  class ParenthesizedExpression < UnaryExpression; end

  # A boolean not expression, reversing the truth of the unary expr.
  #
  class NotExpression < UnaryExpression; end

  # An arithmetic expression reversing the polarity of the numeric unary expr.
  #
  class UnaryMinusExpression < UnaryExpression; end

  # An assignment expression assigns a value to the lval() of the left_expr.
  #
  class AssignmentExpression < BinaryExpression
    has_attr 'operator', RGen::MetamodelBuilder::DataTypes::Enum.new([:'=', :'+=', :'-=']), :lowerBound => 1
  end

  # An arithmetic expression applies an arithmetic operator on left and right expressions.
  #
  class ArithmeticExpression < BinaryExpression
    has_attr 'operator', RGen::MetamodelBuilder::DataTypes::Enum.new([:'+', :'-', :'*', :'%', :'/', :'<<', :'>>' ]), :lowerBound => 1
  end

  # A relationship expression associates the left and right expressions
  #
  class RelationshipExpression < BinaryExpression
    has_attr 'operator', RGen::MetamodelBuilder::DataTypes::Enum.new([:'->', :'<-', :'~>', :'<~']), :lowerBound => 1
  end

  # A binary expression, that accesses the value denoted by right in left. i.e. typically
  # expressed concretely in a language as left[right].
  #
  class AccessExpression < Expression
    contains_one_uni 'left_expr', Expression, :lowerBound => 1
    contains_many_uni 'keys', Expression, :lowerBound => 1
  end

  # A comparison expression compares left and right using a comparison operator.
  #
  class ComparisonExpression < BinaryExpression
    has_attr 'operator', RGen::MetamodelBuilder::DataTypes::Enum.new([:'==', :'!=', :'<', :'>', :'<=', :'>=' ]), :lowerBound => 1
  end

  # A match expression matches left and right using a matching operator.
  #
  class MatchExpression < BinaryExpression
    has_attr 'operator', RGen::MetamodelBuilder::DataTypes::Enum.new([:'!~', :'=~']), :lowerBound => 1
  end

  # An 'in' expression checks if left is 'in' right
  #
  class InExpression < BinaryExpression; end

  # A boolean expression applies a logical connective operator (and, or) to left and right expressions.
  #
  class BooleanExpression < BinaryExpression
    abstract
  end

  # An and expression applies the logical connective operator and to left and right expression
  # and does not evaluate the right expression if the left expression is false.
  #
  class AndExpression < BooleanExpression; end

  # An or expression applies the logical connective operator or to the left and right expression
  # and does not evaluate the right expression if the left expression is true
  #
  class OrExpression < BooleanExpression; end

  # A literal list / array containing 0:M expressions.
  #
  class LiteralList < Expression
    contains_many_uni 'values', Expression
  end

  # A Keyed entry has a key and a value expression. It is typically used as an entry in a Hash.
  #
  class KeyedEntry < Positioned
    contains_one_uni 'key', Expression, :lowerBound => 1
    contains_one_uni 'value', Expression, :lowerBound => 1
  end

  # A literal hash is a collection of KeyedEntry objects
  #
  class LiteralHash < Expression
    contains_many_uni 'entries', KeyedEntry
  end

  # A block contains a list of expressions
  #
  class BlockExpression < Expression
    contains_many_uni 'statements', Expression
  end

  # A case option entry in a CaseStatement
  #
  class CaseOption < Expression
    contains_many_uni 'values', Expression, :lowerBound => 1
    contains_one_uni 'then_expr', Expression, :lowerBound => 1
  end

  # A case expression has a test, a list of options (multi values => block map).
  # One CaseOption may contain a LiteralDefault as value. This option will be picked if nothing
  # else matched.
  #
  class CaseExpression < Expression
    contains_one_uni 'test', Expression, :lowerBound => 1
    contains_many_uni 'options', CaseOption
  end

  # A query expression is an expression that is applied to some collection.
  # The contained optional expression may contain different types of relational expressions depending
  # on what the query is applied to.
  #
  class QueryExpression < Expression
    abstract
    contains_one_uni 'expr', Expression, :lowerBound => 0
  end

  # An exported query is a special form of query that searches for exported objects.
  #
  class ExportedQuery < QueryExpression
  end

  # A virtual query is a special form of query that searches for virtual objects.
  #
  class VirtualQuery < QueryExpression
  end

  # An attribute operation sets or appends a value to a named attribute.
  #
  class AttributeOperation < Positioned
    has_attr 'attribute_name', String, :lowerBound => 1
    has_attr 'operator', RGen::MetamodelBuilder::DataTypes::Enum.new([:'=>', :'+>', ]), :lowerBound => 1
    contains_one_uni 'value_expr', Expression, :lowerBound => 1
  end

  # An object that collects stored objects from the central cache and returns
  # them to the current host. Operations may optionally be applied.
  #
  class CollectExpression < Expression
    contains_one_uni 'type_expr', Expression, :lowerBound => 1
    contains_one_uni 'query', QueryExpression, :lowerBound => 1
    contains_many_uni 'operations', AttributeOperation
  end

  class Parameter < Positioned
    has_attr 'name', String, :lowerBound => 1
    contains_one_uni 'value', Expression
  end

  # Abstract base class for definitions.
  #
  class Definition < Expression
    abstract
  end

  # Abstract base class for named and parameterized definitions.
  class NamedDefinition < Definition
    abstract
    has_attr 'name', String, :lowerBound => 1
    contains_many_uni 'parameters', Parameter
    contains_one_uni 'body', Expression
  end

  # A resource type definition (a 'define' in the DSL).
  #
  class ResourceTypeDefinition < NamedDefinition
  end

  # A node definition matches hosts using Strings, or Regular expressions. It may inherit from
  # a parent node (also using a String or Regular expression).
  #
  class NodeDefinition < Definition
    contains_one_uni 'parent', Expression
    contains_many_uni 'host_matches', Expression, :lowerBound => 1
    contains_one_uni 'body', Expression
  end

  class LocatableExpression < Expression
    has_many_attr 'line_offsets', Integer
    has_attr 'locator', Object, :lowerBound => 1, :transient => true

    module ClassModule
      # Go through the gymnastics of making either value or pattern settable
      # with synchronization to the other form. A derived value cannot be serialized
      # and we want to serialize the pattern. When recreating the object we need to
      # recreate it from the pattern string.
      # The below sets both values if one is changed.
      #
      def locator
        unless result = getLocator
          setLocator(result = Puppet::Pops::Parser::Locator.locator(source_text, source_ref(), line_offsets))
        end
        result
      end
    end
  end

  # Contains one expression which has offsets reported virtually (offset against the Program's
  # overall locator).
  #
  class SubLocatedExpression < Expression
    contains_one_uni 'expr', Expression, :lowerBound => 1

    # line offset index for contained expressions
    has_many_attr 'line_offsets', Integer

    # Number of preceding lines (before the line_offsets)
    has_attr 'leading_line_count', Integer

    # The offset of the leading source line (i.e. size of "left margin").
    has_attr 'leading_line_offset', Integer

    # The locator for the sub-locatable's children (not for the sublocator itself)
    # The locator is not serialized and is recreated on demand from the indexing information
    # in self.
    #
    has_attr 'locator', Object, :lowerBound => 1, :transient => true

    module ClassModule
      def locator
        unless result = getLocator
          # Adapt myself to get the Locator for me
          adapter = Puppet::Pops::Adapters::SourcePosAdapter.adapt(self)
          # Get the program (root), and deal with case when not contained in a program
          program = eAllContainers.find {|c| c.is_a?(Program) }
          source_ref = program.nil? ? '' : program.source_ref

          # An outer locator is needed since SubLocator only deals with offsets. This outer locator
          # has 0,0 as origin.
          outer_locator = Puppet::Pops::Parser::Locator.locator(adpater.extract_text, source_ref, line_offsets)

          # Create a sublocator that describes an offset from the outer
          # NOTE: the offset of self is the same as the sublocator's leading_offset
          result = Puppet::Pops::Parser::Locator::SubLocator.new(outer_locator,
            leading_line_count, offset, leading_line_offset)
          setLocator(result)
        end
        result
      end
    end
  end

  # A heredoc is a wrapper around a LiteralString or a ConcatenatedStringExpression with a specification
  # of syntax. The expectation is that "syntax" has meaning to a validator. A syntax of nil or '' means
  # "unspecified syntax".
  #
  class HeredocExpression < Expression
    has_attr 'syntax', String
    contains_one_uni 'text_expr', Expression, :lowerBound => 1
  end

  # A class definition
  #
  class HostClassDefinition < NamedDefinition
    has_attr 'parent_class', String
  end

  # i.e {|parameters| body }
  class LambdaExpression < Expression
    contains_many_uni 'parameters', Parameter
    contains_one_uni 'body', Expression
  end

  # If expression. If test is true, the then_expr part should be evaluated, else the (optional)
  # else_expr. An 'elsif' is simply an else_expr = IfExpression, and 'else' is simply else == Block.
  # a 'then' is typically a Block.
  #
  class IfExpression < Expression
    contains_one_uni 'test', Expression, :lowerBound => 1
    contains_one_uni 'then_expr', Expression, :lowerBound => 1
    contains_one_uni 'else_expr', Expression
  end

  # An if expression with boolean reversed test.
  #
  class UnlessExpression < IfExpression
  end

  # An abstract call.
  #
  class CallExpression < Expression
    abstract
    # A bit of a crutch; functions are either procedures (void return) or has an rvalue
    # this flag tells the evaluator that it is a failure to call a function that is void/procedure
    # where a value is expected.
    #
    has_attr 'rval_required', Boolean, :defaultValueLiteral => "false"
    contains_one_uni 'functor_expr', Expression, :lowerBound => 1
    contains_many_uni 'arguments', Expression
    contains_one_uni 'lambda', Expression
  end

  # A function call where the functor_expr should evaluate to something callable.
  #
  class CallFunctionExpression < CallExpression; end

  # A function call where the given functor_expr should evaluate to the name
  # of a function.
  #
  class CallNamedFunctionExpression < CallExpression; end

  # A method/function call where the function expr is a NamedAccess and with support for
  # an optional lambda block
  #
  class CallMethodExpression < CallExpression
  end

  # Abstract base class for literals.
  #
  class Literal < Expression
    abstract
  end

  # A literal value is an abstract value holder. The type of the contained value is
  # determined by the concrete subclass.
  #
  class LiteralValue < Literal
    abstract
  end

  # A Regular Expression Literal.
  #
  class LiteralRegularExpression < LiteralValue
    has_attr 'value', Object, :lowerBound => 1, :transient => true
    has_attr 'pattern', String, :lowerBound => 1

    module ClassModule
      # Go through the gymnastics of making either value or pattern settable
      # with synchronization to the other form. A derived value cannot be serialized
      # and we want to serialize the pattern. When recreating the object we need to
      # recreate it from the pattern string.
      # The below sets both values if one is changed.
      #
      def value= regexp
        setValue regexp
        setPattern regexp.to_s
      end

      def pattern= regexp_string
        setPattern regexp_string
        setValue Regexp.new(regexp_string)
      end
    end

  end

  # A Literal String
  #
  class LiteralString < LiteralValue
    has_attr 'value', String, :lowerBound => 1
  end

  class LiteralNumber < LiteralValue
    abstract
  end

  # A literal number has a radix of decimal (10), octal (8), or hex (16) to enable string conversion with the input radix.
  # By default, a radix of 10 is used.
  #
  class LiteralInteger < LiteralNumber
    has_attr 'radix', Integer, :lowerBound => 1, :defaultValueLiteral => "10"
    has_attr 'value', Integer, :lowerBound => 1
  end

  class LiteralFloat < LiteralNumber
    has_attr 'value', Float, :lowerBound => 1
  end

  # The DSL `undef`.
  #
  class LiteralUndef < Literal; end

  # The DSL `default`
  class LiteralDefault < Literal; end

  # DSL `true` or `false`
  class LiteralBoolean < LiteralValue
    has_attr 'value', Boolean, :lowerBound => 1
  end

  # A text expression is an interpolation of an expression. If the embedded expression is
  # a QualifiedName, it is taken as a variable name and resolved. All other expressions are evaluated.
  # The result is transformed to a string.
  #
  class TextExpression < UnaryExpression; end

  # An interpolated/concatenated string. The contained segments are expressions. Verbatim sections
  # should be LiteralString instances, and interpolated expressions should either be
  # TextExpression instances (if QualifiedNames should be turned into variables), or any other expression
  # if such treatment is not needed.
  #
  class ConcatenatedString < Expression
    contains_many_uni 'segments', Expression
  end

  # A DSL NAME (one or multiple parts separated by '::').
  #
  class QualifiedName < LiteralValue
    has_attr 'value', String, :lowerBound => 1
  end

  # A DSL CLASSREF (one or multiple parts separated by '::' where (at least) the first part starts with an upper case letter).
  #
  class QualifiedReference < LiteralValue
    has_attr 'value', String, :lowerBound => 1
  end

  # A Variable expression looks up value of expr (some kind of name) in scope.
  # The expression is typically a QualifiedName, or QualifiedReference.
  #
  class VariableExpression < UnaryExpression; end

  # Epp start
  class EppExpression < Expression
    has_attr 'see_scope', Boolean
    contains_one_uni 'body', Expression
  end

  # A string to render
  class RenderStringExpression < LiteralString
  end

  # An expression to evluate and render
  class RenderExpression < UnaryExpression
  end

  # A resource body describes one resource instance
  #
  class ResourceBody < Positioned
    contains_one_uni 'title', Expression
    contains_many_uni 'operations', AttributeOperation
  end

  # An abstract resource describes the form of the resource (regular, virtual or exported)
  # and adds convenience methods to ask if it is virtual or exported.
  # All derived classes may not support all forms, and these needs to be validated
  #
  class AbstractResource < Expression
    abstract
    has_attr 'form', RGen::MetamodelBuilder::DataTypes::Enum.new([:regular, :virtual, :exported ]), :lowerBound => 1, :defaultValueLiteral => "regular"
    has_attr 'virtual', Boolean, :derived => true
    has_attr 'exported', Boolean, :derived => true

    module ClassModule
      def virtual_derived
        form == :virtual || form == :exported
      end

      def exported_derived
        form == :exported
      end
    end

  end

  # A resource expression is used to instantiate one or many resource. Resources may optionally
  # be virtual or exported, an exported resource is always virtual.
  #
  class ResourceExpression < AbstractResource
    contains_one_uni 'type_name', Expression, :lowerBound => 1
    contains_many_uni 'bodies', ResourceBody
  end

  # A resource defaults sets defaults for a resource type. This class inherits from AbstractResource
  # but does only support the :regular form (this is intentional to be able to produce better error messages
  # when illegal forms are applied to a model.
  #
  class ResourceDefaultsExpression < AbstractResource
    contains_one_uni 'type_ref', QualifiedReference
    contains_many_uni 'operations', AttributeOperation
  end

  # A resource override overrides already set values.
  #
  class ResourceOverrideExpression < Expression
    contains_one_uni 'resources', Expression, :lowerBound => 1
    contains_many_uni 'operations', AttributeOperation
  end

  # A selector entry describes a map from matching_expr to value_expr.
  #
  class SelectorEntry < Positioned
    contains_one_uni 'matching_expr', Expression, :lowerBound => 1
    contains_one_uni 'value_expr', Expression, :lowerBound => 1
  end

  # A selector expression represents a mapping from a left_expr to a matching SelectorEntry.
  #
  class SelectorExpression < Expression
    contains_one_uni 'left_expr', Expression, :lowerBound => 1
    contains_many_uni 'selectors', SelectorEntry
  end

  # A named access expression looks up a named part. (e.g. $a.b)
  #
  class NamedAccessExpression < BinaryExpression; end

  # A Program is the top level construct returned by the parser
  # it contains the parsed result in the body, and has a reference to the full source text,
  # and its origin. The line_offset's is an array with the start offset of each line.
  #
  class Program < PopsObject
    contains_one_uni 'body', Expression
    has_many 'definitions', Definition
    has_attr 'source_text', String
    has_attr 'source_ref', String
    has_many_attr 'line_offsets', Integer
    has_attr 'locator', Object, :lowerBound => 1, :transient => true

    module ClassModule
      def locator
        unless result = getLocator
          setLocator(result = Puppet::Pops::Parser::Locator.locator(source_text, source_ref(), line_offsets))
        end
        result
      end
    end

  end
end
