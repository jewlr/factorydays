require_relative "factory_days/version"
require_relative "factory_days/business_weekends"
require_relative "holidays"

require 'date'
require 'time'

module FactoryDays

  def check_manufacturers(*manufacturers)
    return manufacturers.empty? ? manufacturers.push(:jewlr) : manufacturers
  end

  def factory_day?(*manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    return true if (1..5).include?(self.wday) && Holidays.on(self, *manufacturers).empty?
    return self.business_weekends(*manufacturers).include?(self) ? true : false
  end

  def next_factory_day(*manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    next_day = self + 1
    while !Holidays.on(next_day, *manufacturers).empty? || ([0,6].include?(next_day.wday) && !self.business_weekends(*manufacturers).include?(next_day)) do
      next_day += 1
    end
    return next_day
  end

  def prev_factory_day(*manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    prev_day = self - 1
    while !Holidays.on(prev_day, *manufacturers).empty? || ([0,6].include?(prev_day.wday) && !self.business_weekends(*manufacturers).include?(prev_day)) do
      prev_day -= 1
    end
    return prev_day
  end

  def days_calculator(until_date, *manufacturers)
    holidays_count = Holidays.between(self, until_date, *manufacturers).size
    weekends_count = (self...until_date).select{|dt|
      self.business_weekends(*manufacturers).include?(dt)
    }.size
    weekdays_count = (self...until_date).reject{|dt|
      [0, 6].include?(dt.wday)
    }.size
    return weekdays_count + weekends_count - holidays_count
  end

  def factory_days_until(until_date, *manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    return 0 if self > until_date
    if manufacturers.include?(:jewlr) && manufacturers.include?(:bogarz)
      return [self.days_calculator(until_date, :jewlr), self.days_calculator(until_date, :bogarz)].max
    end
    return self.days_calculator(until_date, *manufacturers)
  end

  def factory_days_passed(until_date, *manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    return until_date.factory_days_until(self, *manufacturers)
  end
end


class Date
  include FactoryDays
end

class Time
  include FactoryDays
end
