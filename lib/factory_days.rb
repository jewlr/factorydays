require_relative "factory_days/version"
require_relative "factory_days/business_weekends"
require_relative "holidays"

require 'date'
require 'time'

module FactoryDays
  def factoryday?
    return true if (1..5).include?(self.wday) && Holidays.on(self, :jewlr, :bogarz).empty?
    return self.business_weekends.include?(self) ? true : false
  end

  def next_factoryday
    next_day = self + 1
    while !Holidays.on(next_day, :jewlr, :bogarz).empty? || ([0,6].include?(next_day.wday) && !self.business_weekends.include?(next_day)) do
      next_day += 1
    end
    return next_day
  end

  def prev_factoryday
    prev_day = self - 1
    while !Holidays.on(prev_day, :jewlr, :bogarz).empty? || ([0,6].include?(prev_day.wday) && !self.business_weekends.include?(prev_day)) do
      prev_day -= 1
    end
    return prev_day
  end

  def factorydays_until(until_date)
    return 0 if self > until_date
    holidays_count = Holidays.between(self, until_date, :jewlr, :bogarz).size
    weekends_count = (self...until_date).select{|dt|
      self.business_weekends.include?(dt)
    }.size
    weekdays_count = (self...until_date).reject{|dt|
      [0, 6].include?(dt.wday)
    }.size
    return weekdays_count + weekends_count - holidays_count
  end

  def factorydays_passed(until_date)
    return until_date.factorydays_until(self)
  end
end


class Date
  include FactoryDays
end

class Time
  include FactoryDays
end
