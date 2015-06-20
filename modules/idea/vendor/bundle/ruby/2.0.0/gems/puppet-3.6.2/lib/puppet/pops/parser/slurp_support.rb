# This module is an integral part of the Lexer.
# It defines the string slurping behavior - finding the string and non string parts in interpolated
# strings, translating escape sequences in strings to their single character equivalence.
#
# PERFORMANCE NOTE: The various kinds of slurping could be made even more generic, but requires
# additional parameter passing and evaluation of conditional logic.
# TODO: More detailed performance analysis of excessive character escaping and interpolation.
#
module Puppet::Pops::Parser::SlurpSupport

  SLURP_SQ_PATTERN  = /(?:[^\\]|^|[^\\])(?:[\\]{2})*[']/
  SLURP_DQ_PATTERN  = /(?:[^\\]|^|[^\\])(?:[\\]{2})*(["]|[$]\{?)/
  SLURP_UQ_PATTERN  = /(?:[^\\]|^|[^\\])(?:[\\]{2})*([$]\{?|\z)/
  SLURP_ALL_PATTERN = /.*(\z)/m
  SQ_ESCAPES = %w{ \\ ' }
  DQ_ESCAPES = %w{ \\  $ ' " r n t s u}+["\r\n", "\n"]
  UQ_ESCAPES = %w{ \\  $ r n t s u}+["\r\n", "\n"]

  def slurp_sqstring
    # skip the leading '
    @scanner.pos += 1
    str = slurp(@scanner, SLURP_SQ_PATTERN, SQ_ESCAPES, :ignore_invalid_escapes) || lex_error("Unclosed quote after \"'\" followed by '#{followed_by}'")
    str[0..-2] # strip closing "'" from result
  end

  def slurp_dqstring
    scn = @scanner
    last = scn.matched
    str = slurp(scn, SLURP_DQ_PATTERN, DQ_ESCAPES, false)
    unless str
      lex_error("Unclosed quote after #{format_quote(last)} followed by '#{followed_by}'")
    end

    # Terminator may be a single char '"', '$', or two characters '${' group match 1 (scn[1]) from the last slurp holds this
    terminator = scn[1]
    [str[0..(-1 - terminator.length)], terminator]
  end

   # Copy from old lexer - can do much better
   def slurp_uqstring
     scn = @scanner
     last = scn.matched
     ignore = true
     str = slurp(scn, @lexing_context[:uq_slurp_pattern], @lexing_context[:escapes], :ignore_invalid_escapes)

     # Terminator may be a single char '$', two characters '${', or empty string '' at the end of intput.
     # Group match 1 holds this.
     # The exceptional case is found by looking at the subgroup 1 of the most recent match made by the scanner (i.e. @scanner[1]).
     # This is the last match made by the slurp method (having called scan_until on the scanner).
     # If there is a terminating character is must be stripped and returned separately.
     #
     terminator = scn[1]
     [str[0..(-1 - terminator.length)], terminator]
   end

  # Slurps a string from the given scanner until the given pattern and then replaces any escaped
  # characters given by escapes into their control-character equivalent or in case of line breaks, replaces the
  # pattern \r?\n with an empty string.
  # The returned string contains the terminating character. Returns nil if the scanner can not scan until the given
  # pattern.
  #
  def slurp(scanner, pattern, escapes, ignore_invalid_escapes)
    str = scanner.scan_until(pattern) || return

    # Process unicode escapes first as they require getting 4 hex digits
    # If later a \u is found it is warned not to be a unicode escape
    if escapes.include?('u')
      str.gsub!(/\\u([\da-fA-F]{4})/m) {
        [$1.hex].pack("U")
      }
    end

    str.gsub!(/\\([^\r\n]|(?:\r?\n))/m) {
      ch = $1
      if escapes.include? ch
        case ch
        when 'r'   ; "\r"
        when 'n'   ; "\n"
        when 't'   ; "\t"
        when 's'   ; " "
        when 'u'
          Puppet.warning(positioned_message("Unicode escape '\\u' was not followed by 4 hex digits"))
          "\\u"
        when "\n"  ; ''
        when "\r\n"; ''
        else      ch
        end
      else
        Puppet.warning(positioned_message("Unrecognized escape sequence '\\#{ch}'")) unless ignore_invalid_escapes
        "\\#{ch}"
      end
    }
    str
  end
end
