# require_relative 'factory_days/business_weekends'
require_relative 'holidays'

module ActiveSupport
  module CoreExtensions
    module Date
      module FactoryDays
        def check_manufacturers(*manufacturers)
          manufacturers.empty? ? manufacturers.push(:jewlr) : manufacturers
        end

        def factory_day?(*manufacturers)
          manufacturers = check_manufacturers(*manufacturers)
          return true if (1..5).cover?(wday) && Holidays.on(self, *manufacturers, :observed).empty?
          return business_weekends(*manufacturers).include?(self) ? true : false
        end

        def next_factory_day(*manufacturers, num_days: 1, check_holiday_on_start_date_only: false, secondary_holiday_region: nil)
          manufacturers = check_manufacturers(*manufacturers)
          day_count = 0
          next_day = self
          while day_count < num_days
            next_day += 1.days
            holiday_region = check_holiday_on_start_date_only ? nil : *manufacturers
            if secondary_holiday_region && !check_holiday_on_start_date_only
              holiday_region = secondary_holiday_region
            end
            if next_day.factory_day?(holiday_region)
              day_count += 1
            end
          end
          next_day
        end

        def prev_factory_day(*manufacturers, num_days:1)
          manufacturers = check_manufacturers(*manufacturers)
          day_count = 0
          prev_day = self
          while day_count < num_days
            prev_day -= 1.days
            if prev_day.factory_day?(*manufacturers)
              day_count += 1
            end
          end
          prev_day
        end

        def days_calculator(until_date, *manufacturers)
          holidays_count = Holidays.between(self, until_date, *manufacturers).size
          weekends_count = (self...until_date).count { |dt| business_weekends(*manufacturers).include?(dt) }
          weekdays_count = (self...until_date).count { |dt| ![0, 6].include?(dt.wday) } + ([0, 6].include?(self.wday) ? 1 : 0)
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
    end
  end
end

module ActiveSupport
  module CoreExtensions
    module Time
      module FactoryDays
        def check_manufacturers(*manufacturers)
          manufacturers.empty? ? manufacturers.push(:jewlr) : manufacturers
        end

        def factory_day?(*manufacturers)
          manufacturers = check_manufacturers(*manufacturers)
          if (1..5).cover?(wday) && Holidays.on(self, *manufacturers, :observed).empty?
            return true
          else
            return business_weekends(*manufacturers).include?(self) ? true : false
          end
        end

        def next_factory_day(*manufacturers, num_days:1)
          manufacturers = check_manufacturers(*manufacturers)
          day_count = 0
          next_day = self
          while day_count < num_days
            next_day += 1.days
            if next_day.factory_day?
              day_count += 1
            end
          end
          next_day
        end

        def prev_factory_day(*manufacturers, num_days:1)
          manufacturers = check_manufacturers(*manufacturers)
          day_count = 0
          prev_day = self
          while day_count < num_days
            prev_day -= 1.days
            if prev_day.factory_day?
              day_count += 1
            end
          end
          prev_day
        end
      end
    end
  end
end

# extending date module to support FactoryDays
class Date
  include ActiveSupport::CoreExtensions::Date::FactoryDays
end

#extending time module to support FactoryDays
class Time
  include ActiveSupport::CoreExtensions::Time::FactoryDays
end