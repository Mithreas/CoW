class AnimalTranslator < Translator
  protected
    def word(s)
      "'" * s.length
    end

    def colour
      return "\x5e\x7c\x40"
    end
end
