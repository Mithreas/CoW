class GenericTranslator < Translator
  protected
    def initialize(lang)
      @lang = lang
    end

    def is_valid
      return [:ab, :ce, :dw, :el, :gn, :go, :ha, :in, :or, :un].include?(@lang)
    end

    def get_subc
      case @lang
        when :ab
        {
          "a" => "oo",
          "b" => "n",
          "c" => "m",
          "d" => "g",
          "e" => "a",
          "f" => "k",
          "g" => "s",
          "h" => "d",
          "i" => "oo",
          "j" => "h",
          "k" => "b",
          "l" => "l",
          "m" => "p",
          "n" => "t",
          "o" => "e",
          "p" => "b",
          "q" => "ch",
          "r" => "n",
          "s" => "m",
          "t" => "g",
          "u" => "ae",
          "v" => "ts",
          "w" => "b",
          "x" => "bb",
          "y" => "ee",
          "z" => "z"
        }
        when :ce
        {
          "a" => "a",
          "b" => "p",
          "c" => "v",
          "d" => "t",
          "e" => "el",
          "f" => "b",
          "g" => "w",
          "h" => "r",
          "i" => "i",
          "j" => "m",
          "k" => "x",
          "l" => "h",
          "m" => "s",
          "n" => "c",
          "o" => "u",
          "p" => "q",
          "q" => "d",
          "r" => "n",
          "s" => "l",
          "t" => "y",
          "u" => "o",
          "v" => "j",
          "w" => "f",
          "x" => "g",
          "y" => "z",
          "z" => "k"
        }
        when :dw
        {
          "a" => "az",
          "b" => "po",
          "c" => "zi",
          "d" => "t",
          "e" => "a",
          "f" => "wa",
          "g" => "k",
          "h" => "'",
          "i" => "a",
          "j" => "dr",
          "k" => "g",
          "l" => "n",
          "m" => "l",
          "n" => "r",
          "o" => "ur",
          "p" => "rh",
          "q" => "k",
          "r" => "h",
          "s" => "th",
          "t" => "k",
          "u" => "'",
          "v" => "g",
          "w" => "zh",
          "x" => "q",
          "y" => "o",
          "z" => "j"
        }
        when :el
        {
          "a" => "il",
          "b" => "f",
          "c" => "ny",
          "d" => "w",
          "e" => "a",
          "f" => "o",
          "g" => "v",
          "h" => "ir",
          "i" => "e",
          "j" => "qu",
          "k" => "n",
          "l" => "c",
          "m" => "s",
          "n" => "l",
          "o" => "e",
          "p" => "ty",
          "q" => "h",
          "r" => "m",
          "s" => "la",
          "t" => "an",
          "u" => "y",
          "v" => "el",
          "w" => "am",
          "x" => "'",
          "y" => "a",
          "z" => "j"
        }
        when :gn
        {
          "a" => "y",
          "b" => "p",
          "c" => "l",
          "d" => "t",
          "e" => "a",
          "f" => "v",
          "g" => "k",
          "h" => "r",
          "i" => "e",
          "j" => "z",
          "k" => "g",
          "l" => "m",
          "m" => "s",
          "n" => "h",
          "o" => "u",
          "p" => "b",
          "q" => "x",
          "r" => "n",
          "s" => "c",
          "t" => "d",
          "u" => "i",
          "v" => "j",
          "w" => "f",
          "x" => "q",
          "y" => "o",
          "z" => "w"
        }
        when :go
        {
          "a" => "u",
          "b" => "p",
          "c" => "c",
          "d" => "t",
          "e" => "'",
          "f" => "v",
          "g" => "k",
          "h" => "r",
          "i" => "o",
          "j" => "z",
          "k" => "g",
          "l" => "m",
          "m" => "s",
          "n" => "n",
          "o" => "u",
          "p" => "b",
          "q" => "q",
          "r" => "n",
          "s" => "k",
          "t" => "d",
          "u" => "u",
          "v" => "v",
          "w" => "'",
          "x" => "x",
          "y" => "o",
          "z" => "w"
        }
        when :ha
        {
          "a" => "e",
          "b" => "p",
          "c" => "s",
          "d" => "t",
          "e" => "i",
          "f" => "w",
          "g" => "k",
          "h" => "n",
          "i" => "u",
          "j" => "v",
          "k" => "g",
          "l" => "c",
          "m" => "l",
          "n" => "r",
          "o" => "y",
          "p" => "b",
          "q" => "x",
          "r" => "h",
          "s" => "m",
          "t" => "d",
          "u" => "o",
          "v" => "f",
          "w" => "z",
          "x" => "q",
          "y" => "a",
          "z" => "j"
        }
        when :in
        {
          "a" => "o",
          "b" => "c",
          "c" => "r",
          "d" => "j",
          "e" => "a",
          "f" => "v",
          "g" => "k",
          "h" => "r",
          "i" => "y",
          "j" => "z",
          "k" => "g",
          "l" => "m",
          "m" => "z",
          "n" => "r",
          "o" => "y",
          "p" => "k",
          "q" => "r",
          "r" => "n",
          "s" => "k",
          "t" => "d",
          "u" => "'",
          "v" => "r",
          "w" => "'",
          "x" => "k",
          "y" => "i",
          "z" => "g"
        }
        when :or
        {
          "a" => "ha",
          "b" => "p",
          "c" => "z",
          "d" => "t",
          "e" => "o",
          "f" => "f",
          "g" => "k",
          "h" => "r",
          "i" => "a",
          "j" => "m",
          "k" => "g",
          "l" => "h",
          "m" => "r",
          "n" => "k",
          "o" => "u",
          "p" => "b",
          "q" => "k",
          "r" => "h",
          "s" => "g",
          "t" => "n",
          "u" => "u",
          "v" => "g",
          "w" => "r",
          "x" => "r",
          "y" => "'",
          "z" => "m"
        }
        when :un
        {
          "a" => "il",
          "b" => "f",
          "c" => "st",
          "d" => "w",
          "e" => "a",
          "f" => "o",
          "g" => "v",
          "h" => "ir",
          "i" => "e",
          "j" => "vi",
          "k" => "go",
          "l" => "c",
          "m" => "li",
          "n" => "l",
          "o" => "e",
          "p" => "ty",
          "q" => "r",
          "r" => "m",
          "s" => "la",
          "t" => "an",
          "u" => "y",
          "v" => "el",
          "w" => "ky",
          "x" => "'",
          "y" => "a",
          "z" => "p'"
        }
        else nil
      end
    end

    def colour
      case @lang
        when :ab then return "\x54\x20\x20"
        when :ce then return "\xfe\xec\x95"
        when :dw then return "\x89\x87\x79"
        when :el then return "\xca\xdf\x74"
        when :gn then return "\xc3\x99\x56"
        when :go then return "\x74\xa6\x4c"
        when :ha then return "\xd6\xb9\x47"
        when :in then return "\xb2\x2e\x20"
        when :or then return "\x5d\x6e\x44"
        when :un then return "\x80\x32\xa1"
        else return nil
      end
    end
end
