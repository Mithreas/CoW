=begin
********************************************************************************
translator/Translator.rb

Language system, translates from one language to another. Typical usage:

  Translator.create(:el).translate("Some string to translate.")

Translator must be subclassed in order to do anything useful. Different
languages parse text in different ways, but Translator provides a framework from
which subclasses may deviate as necessary by overriding appropriate protected
methods. If the flow is to reach the word() method, then get_subc() needs to be
defined: this should return a hash of letter substitutions, e.g. {'a' => 'e',
'b' => 'k', ...} will translate "baa" into "kee".

Most languages are defined in GenericTranslator. Special ones have their own
classes.

********************************************************************************
CLASS METHODS

/**
 * Creates a new Translator for the language, or reuses an existing one if one
 * has already been created. Translators are stored statically in the Translator
 * class.
 *
 * @param lang The language to use, a symbol with the language key, e.g. :el for
 *             elven.
 * @return Translator An object which is a subclass of Translator.
 */
static Translator.create(lang)

/**
 * Translates string to the current Translator's language, returning the result.
 *
 * @param string The text to return.
 */
public Translator.translate(string)

/**
 * Determines whether or not the object is a valid Translator or not. This
 * method can be overridden by subclasses of Translator to provide specific
 * conditions - the default condition is only that the current Translator is not
 * the base class.
 *
 * @return boolean True if the translator is capable of translating text, false
 *                 otherwise.
 */
public Translator.is_valid()

********************************************************************************
=end


# Declaration required to load the other translators.
class Translator
end

require_relative 'AnimalTranslator'
require_relative 'DrowTranslator'
require_relative 'GenericTranslator'
require_relative 'SignTranslator'
require_relative 'ThiefTranslator'
require_relative 'DraconicTranslator'
require_relative 'GiantTranslator'

class Translator
  INVALID = -1
  ASTERISK_EMOTE = 0
  BRACKET_EMOTE = 1
  COLON_EMOTE_FORWARD = 2
  COLON_EMOTE_BACKWARD = 3

  EMOTE_STYLE_STANDARD = 0
  EMOTE_STYLE_NOVEL = 1

  @@translators = {}

  public
    def translate(string, style, modify)
        if !is_valid
            return ''
        end

        if style == EMOTE_STYLE_NOVEL
            return _translate_novel(string, modify)
        end

        return _translate_standard(string, modify)
    end

    def is_valid
      return self.class.name != "Translator"
    end

    def Translator.create(lang)
      if @@translators[lang] == nil
        case lang
          when :an then @@translators[lang] = AnimalTranslator.new
          when :si then @@translators[lang] = SignTranslator.new
          when :th then @@translators[lang] = ThiefTranslator.new
          when :xa then @@translators[lang] = DrowTranslator.new
          when :dr then @@translators[lang] = DraconicTranslator.new
          when :gi then @@translators[lang] = GiantTranslator.new
          else @@translators[lang] = GenericTranslator.new(lang)
        end
      end
      return @@translators[lang]
    end

  protected
    def _translate_standard(string, modify)
        ret = ''
        depth = 0
        index_start = 0
        index_end = -1
        working_on = INVALID

        # Asterisk emotes become plain.
        # Single brackets '[]' become plain and the brackets are stripped.
        # Double brackets '[[]]' become plain, and only the outer bracket is stripped.
        # We use a bracket balancing algorithm here. For each opening bracket, the depth
        # is increased by 1. For each closing bracket, it is decreased.
        string.each_char.with_index do |c, index|
            case c
                when '['
                    if working_on == INVALID || working_on == BRACKET_EMOTE
                        depth += 1
                        if depth == 1
                            ret += _translate(string[index_start, index - index_start], modify)
                            index_start = index + 1
                            working_on = BRACKET_EMOTE
                        end
                    end
                # End case '['

                when ']'
                    if working_on == BRACKET_EMOTE
                        depth -= 1
                        if depth == 0
                            index_end = index - index_start
                            working_on = INVALID
                        end
                    end
                # End case ']'

                when '*'
                    if working_on == INVALID || working_on == ASTERISK_EMOTE
                        if depth == 0
                            ret += _translate(string[index_start, index - index_start], modify)
                            depth = 1
                            index_start = index
                            working_on = ASTERISK_EMOTE
                        else
                            depth = 0
                            index_end = index - index_start + 1
                            working_on = INVALID
                        end
                    end
                # End case '*'

                when ':'
                    if working_on == INVALID || working_on == COLON_EMOTE_FORWARD
                        depth += 1
                        if depth == 1
                            # Only match this colon if the next symbol is also a colon.
                            # This needs to be done because a single colon can be used in normal chat.
                            if index + 1 < string.length && string[index + 1].chr == ':'
                                ret += _translate(string[index_start, index - index_start], modify)
                                index_start = index
                                working_on = COLON_EMOTE_FORWARD
                            else
                                depth -= 1
                            end
                        elsif depth == 2
                            working_on = COLON_EMOTE_BACKWARD
                        end
                    elsif working_on == COLON_EMOTE_BACKWARD
                        depth -= 1
                        if depth == 0
                            index_end = index - index_start + 1
                            working_on = INVALID
                        end
                    end
                # End case ':'
            end

            if index_end != -1
                ret += string[index_start, index_end]
                index_start = index + 1
                index_end = -1
            else
                # If this is the last character in the string, we should just display
                # what we've got.
                if index == string.length - 1
                    if depth == 0
                        # This is just normal text.
                        ret += _translate(string[index_start, index - index_start + 1], modify)
                    else
                        # The user probably screwed up and forgot to close a symbol, so
                        # assume it shouldn't be translated.
                        ret += string[index_start, index - index_start + 1]
                    end
                end
            end
        end

        return ret
    end

    def _translate_novel(string, modify)
        ret = ''
        index_start = 0
        working_on_quotes = 0
        working_on_brackets = 0

        string.each_char.with_index do |c, index|
            case c
                when '"'
                    if working_on_quotes == 0
                        ret += string[index_start, index - index_start]
                        working_on_quotes = 1
                        index_start = index
                    else
                        ret += _translate(string[index_start, index - index_start + 1], modify)
                        working_on_quotes = 0
                        index_start = index + 1
                    end
                # End case '"'

                when '['
                    if working_on_quotes == 0
                        ret += string[index_start, index - index_start]
                    else
                        ret += _translate(string[index_start, index - index_start], modify)
                    end

                    working_on_brackets = 1
                    index_start = index + 1
                # End case '['

                when ']'
                    ret += string[index_start, index - index_start]
                    working_on_brackets = 0
                    index_start = index + 1
                # End case ']'
            end
        end

        if working_on_quotes == 0 || working_on_brackets == 1
            ret += string[index_start, string.length - index_start]
        else
            # The user probably screwed up and forgot to close a symbol.
            ret += _translate(string[index_start, string.length - index_start], modify)
        end

        return ret
    end

    # Translate all of s into another language. It is assumed that none of s
    # should be left out of the translation.
    def _translate(s, modify)
      s.tr!('äÄöÖüÜ', 'aAoOuU')

      text = s;
      if modify
        text = punctuation(s)
      end

      if defined? colour
        return '<c' + colour + '>' + text + '</c>'
      else
        return text
      end
    end

    # Look for punctuation splits in s, including spaces. The only punctuation
    # mark not included is apostrophe - these can play a part in translation.
    def punctuation(s)
      i = 0
      j = 0
      ret = ''
      s.each_char do |c|
        if !"abcdefghijklmnopqrstuvwxyz'".include?(c.downcase)
          ret += word(s[i,j-i]) + c
          i = j + 1
        end
        j += 1
      end

      if j > i
        ret += word(s[i..j])
      end

      return ret
    end

    # Translates s character by character. get_subc should be defined to return
    # a map with each lowercase letter a-z a key. If get_subc is not defined,
    # this method must not be called.
    def word(s)
      subc = get_subc()
      x = ''
      s.each_char do |c|
        if c.upcase.eql?(c)
          x += (subc[c.downcase] or c).capitalize
        else
          x += subc[c] or c
        end
      end
      return x
    end
end
