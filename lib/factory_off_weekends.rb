require 'date'

module FactoryOffWeekends
  def self.factory_off?(date:, manufacturers:)
    return false unless factory_name.any?

    manufacturers = Array(manufacturers)

    factory_off_weekends = {
      jewlr: [
        Date.new(2023, 1, 7),
        Date.new(2023, 1, 8),
      ],
      bogarz: [
        Date.new(2016, 2, 13),
        Date.new(2016, 2, 14),
      ],
    }

    factory_off_weekends_dates = manufacturers.map { |manufacturer| factory_off_weekends[manufacturer] }.inject(:&)
    if date.include? factory_off_weekends_dates
      true
    else
      false
    end
  end
end

class Date
  include FactoryOffWeekends

end
