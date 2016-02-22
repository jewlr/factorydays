require 'date'

module BusinessWeekends
  def business_weekends(*manufacturers)
     jewlr_weekends = [
        Date.new(2016, 2, 6),
        Date.new(2016, 2, 7)
     ]

    bogarz_weekends = [
      Date.new(2016,2,13),
      Date.new(2016,2,14)
    ]

    if manufacturers.include?(:jewlr) && manufacturers.include?(:bogarz)
      return jewlr_weekends & bogarz_weekends
    elsif manufacturers.include?(:jewlr)
      return jewlr_weekends
    else
      return bogarz_weekends
    end
  end
end

class Date
  include BusinessWeekends
end

