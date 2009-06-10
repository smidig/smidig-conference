module TalksHelper
  def antall_stemmer(antall)
    case antall 
      when 0 then return "Ingen stemmer"
      when 1 then return "1 stemme"
      else return "#{antall} stemmer"
    end
  end
end
