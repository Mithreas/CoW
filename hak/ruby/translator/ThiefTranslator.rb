class ThiefTranslator < Translator
  public
    def translate(string, style, modify)
      emotes = {
        "a" => "*winks*",
        "b" => "*tilts head*",
        "c" => "*coughs*",
        "d" => "*strokes eyebrow*",
        "e" => "*looks down*",
        "f" => "*frowns*",
        "g" => "*looks up*",
        "h" => "*folds hands*",
        "i" => "*hems*",
        "j" => "*rubs chin*",
        "k" => "*scratches ear*",
        "l" => "*looks around*",
        "m" => "*rubs neck*",
        "n" => "*nods*",
        "o" => "*grins*",
        "p" => "*smiles*",
        "q" => "*screws mouth*",
        "r" => "*rolls eyes*",
        "s" => "*scratches nose*",
        "t" => "*turns a little*",
        "u" => "*looks tired*",
        "v" => "*strokes hair*",
        "w" => "*sneezes*",
        "x" => "*stretches*",
        "y" => "*yawns*",
        "z" => "*shrugs*"
      }

      emoteValue = emotes[string.downcase[0]] or "*nods*";

      if modify
        return emoteValue
      else
        return emoteValue + " (" + string + ")"
      end
    end
end
