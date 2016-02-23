require 'date'

module BusinessWeekends
  def business_weekends(*manufacturers)
    weekends = {
      :jewlr => [
        Date.new(2016, 2, 6),
        Date.new(2016, 2, 7)
      ],
      :bogarz => [
        Date.new(2016,2,13),
        Date.new(2016,2,14)
      ]
    }

    weekend_dates = manufacturers.map{|manufacturer| weekends[manufacturer]}.inject(:&)
    return weekend_dates
  end
end

class Date
  include BusinessWeekends
end
