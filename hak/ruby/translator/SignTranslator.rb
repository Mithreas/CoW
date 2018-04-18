class SignTranslator < Translator
  public
    def translate(string, style, modify)
      emoteValue = "<c\x68\x59\x6a>*makes a few quick hand movements*"

      if modify
        return emoteValue + "</c>"
      else
        return emoteValue + " (" + string + ")</c>"
      end
    end
end
