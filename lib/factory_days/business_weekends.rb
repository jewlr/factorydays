require 'date'

module BusinessWeekends
  def business_weekends
     weekends = [
        Date.new(2016, 2, 5),
        Date.new(2016, 2, 6)
     ]
     return weekends
  end
end

class Date
  include BusinessWeekends
end

