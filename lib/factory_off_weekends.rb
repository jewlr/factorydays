# frozen_string_literal: true

require 'date'

# this module includes factory off weekends
module FactoryOffWeekends
  def self.factory_off?(date:, manufacturers:)
    return false unless manufacturers.present?

    # in case for DateTime
    date = date.to_date
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

    factory_off_weekends_dates = manufacturers
                                 .map { |manufacturer| factory_off_weekends[manufacturer] }
                                 .inject(:&)
    if factory_off_weekends_dates.include? date
      true
    else
      false
    end
  end
end
