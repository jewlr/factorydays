# require_relative 'factory_days/business_weekends'
require_relative 'holidays'

# module to work with factory days
module FactoryDays
  def check_manufacturers(*manufacturers)
    manufacturers.empty? ? manufacturers.push(:jewlr) : manufacturers
  end

  def factory_day?(*manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    return true \
      if (1..5).cover?(wday) && Holidays.on(self, *manufacturers).empty?
    business_weekends(*manufacturers).include?(self) ? true : false
  end

  def next_factory_day(*manufacturers, num_days:1)
    manufacturers = check_manufacturers(*manufacturers)
    next_day = self + num_days
    while !Holidays.on(next_day, *manufacturers).empty? \
      || ([0, 6].include?(next_day.wday) \
      && !business_weekends(*manufacturers).include?(next_day))
      next_day += 1
    end
    next_day
  end

  def prev_factory_day(*manufacturers, num_days:1)
    manufacturers = check_manufacturers(*manufacturers)
    prev_day = self - num_days
    while !Holidays.on(prev_day, *manufacturers).empty? \
      || ([0, 6].include?(prev_day.wday) \
      && !business_weekends(*manufacturers).include?(prev_day))
      prev_day -= 1
    end
    prev_day
  end

  def days_calculator(until_date, *manufacturers)
    holidays_count = Holidays.between(self, until_date, *manufacturers).size
    weekends_count = (self...until_date).count { |dt| business_weekends(*manufacturers).include?(dt) }
    weekdays_count = (self...until_date).count { |dt| ![0, 6].include?(dt.wday) }
    weekdays_count + weekends_count - holidays_count
  end

  def factory_days_until(until_date, *manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    return 0 if self > until_date
    if manufacturers.include?(:jewlr) && manufacturers.include?(:bogarz)
      return [days_calculator(until_date, :jewlr), days_calculator(until_date, :bogarz)].max
    end
    days_calculator(until_date, *manufacturers)
  end

  def factory_days_passed(until_date, *manufacturers)
    manufacturers = check_manufacturers(*manufacturers)
    until_date.factory_days_until(self, *manufacturers)
  end
end

# extending date module to support FactoryDays
class Date
  include FactoryDays
end

