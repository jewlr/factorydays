require 'date'

module BusinessWeekends
  # NOTE: This can be overriden in project
  def business_weekends(holiday_region=[])
    return [] unless holiday_region.any?
    holiday_region = Array(holiday_region)

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

    weekend_dates = holiday_region.map{|manufacturer| weekends[manufacturer]}.inject(:&)
    return weekend_dates
  end
end

class Date
  include BusinessWeekends
end