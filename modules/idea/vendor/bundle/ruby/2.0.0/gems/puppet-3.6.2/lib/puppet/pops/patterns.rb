# The Patterns module contains common regular expression patters for the Puppet DSL language
module Puppet::Pops::Patterns

  # NUMERIC matches hex, octal, decimal, and floating point and captures three parts
  # 0 = entire matched number, leading and trailing whitespace included
  # 1 = hexadecimal number
  # 2 = non hex integer portion, possibly with leading 0 (octal)
  # 3 = floating point part, starts with ".", decimals and optional exponent
  #
  # Thus, a hex number has group 1 value, an octal value has group 2 (if it starts with 0), and no group 3
  # and a floating point value has group 2 and group 3.
  #
  NUMERIC = %r{^\s*(?:(0[xX][0-9A-Fa-f]+)|(0?\d+)((?:\.\d+)?(?:[eE]-?\d+)?))\s*$}

  # ILLEGAL_P3_1_HOSTNAME matches if a hostname contains illegal characters.
  # This check does not prevent pathological names like 'a....b', '.....', "---". etc.
  ILLEGAL_HOSTNAME_CHARS = %r{[^-\w.]}

  # NAME matches a name the same way as the lexer.
  NAME = %r{\A((::)?[a-z]\w*)(::[a-z]\w*)*\z}

  # CLASSREF_EXT matches a class reference the same way as the lexer - i.e. the external source form
  # where each part must start with a capital letter A-Z.
  # This name includes hyphen, which may be illegal in some cases.
  #
  CLASSREF_EXT = %r{\A((::){0,1}[A-Z][\w]*)+\z}

  # CLASSREF matches a class reference the way it is represented internally in the
  # model (i.e. in lower case).
  # This name includes hyphen, which may be illegal in some cases.
  #
  CLASSREF = %r{\A((::){0,1}[a-z][\w]*)+\z}

  # DOLLAR_VAR matches a variable name including the initial $ character
  DOLLAR_VAR     = %r{\$(::)?(\w+::)*\w+}

  # VAR_NAME matches the name part of a variable (The $ character is not included)
  # Note, that only the final segment may start with an underscore.
  VAR_NAME = %r{\A(:?(::)?[a-z]\w*)*(:?(::)?[a-z_]\w*)\z}

  # A Numeric var name must be the decimal number 0, or a decimal number not starting with 0
  NUMERIC_VAR_NAME = %r{\A(?:0|(?:[1-9][0-9]*))\z}

end
