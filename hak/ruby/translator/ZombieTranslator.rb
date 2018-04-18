class ZombieTranslator < Translator
  public
    def translate(string, style, modify)
      groan = 'Urrrg...'
      case rand(5)
        when 1..2: groan = 'Braiiinnsss...'
        when 3: groan = 'Unnng.'
        when 4: groan = 'More braiiinsss...'
      }
      return "<c\x7c\x7c\x7c>" + groan + '</c>';
    end
end
