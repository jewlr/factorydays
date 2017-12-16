# require_relative 'factory_days/business_weekends'
require_relative 'holidays'

module ActiveSupport
  module CoreExtensions
    module Date
      module FactoryDays

        def factory_day?(holiday_region=nil)
          holiday_region = holiday_region ? Array(holiday_region) : nil
          if holiday_region
            return true if (1..5).cover?(wday) && Holidays.on(self, *holiday_region, :observed).empty?
          else
            return true if (1..5).cover?(wday) && Holidays.on(self, :observed).empty?
          end
          result = business_weekends(holiday_region)
          result = result && result.include?(self) ? true : false
          return result
        end

        def next_factory_day(options={})
          # options
          # :num_days
          # :holiday_region
          # :check_holiday_start_date_only
          # :secondary_holiday_region

          num_days = options[:num_days] || 1
          holiday_region = options[:holiday_region] ? Array(options[:holiday_region]) : nil
          check_holiday_on_start_date_only = options[:check_holiday_start_date_only] || false
          secondary_holiday_region = options[:secondary_holiday_region]

          day_count = 0
          next_day = self
          while day_count < num_days
            next_day += 1.days
            holiday_region = check_holiday_on_start_date_only ? nil : holiday_region
            if secondary_holiday_region && !check_holiday_on_start_date_only
              holiday_region = secondary_holiday_region
            end
            if next_day.factory_day?(holiday_region)
              day_count += 1
            end
          end
          next_day
        end

        def prev_factory_day(options={})
          # options
          # :num_days
          # :holiday_region

          num_days = options[:num_days] || 1
          holiday_region = options[:holiday_region] ? Array(options[:holiday_region]) : nil

          day_count = 0
          prev_day = self
          while day_count < num_days
            prev_day -= 1.days
            if prev_day.factory_day?(holiday_region)
              day_count += 1
            end
          end
          prev_day
        end

        def days_calculator(until_date, holiday_region=nil)
          holiday_region = holiday_region ? Array(holiday_region) : nil
          holidays_count = Holidays.between(self, until_date, holiday_region).select{|holiday|holiday[:date].wday != 0 && holiday[:date].wday != 6}.size
          weekends_count = (self...until_date).count { |dt| business_weekends(holiday_region).include?(dt) }
          weekdays_count = (self...until_date).count { |dt| ![0, 6].include?(dt.wday) } + ([0, 6].include?(self.wday) ? 1 : 0)
          weekdays_count + weekends_count - holidays_count
        end

        def factory_days_until(until_date, holiday_region=nil)
          return 0 if self > until_date

          holiday_region = holiday_region ? Array(holiday_region) : nil
          if holiday_region.include?(:jewlr) && holiday_region.include?(:bogarz)
            return [days_calculator(until_date, :jewlr), days_calculator(until_date, :bogarz)].max
          end
          days_calculator(until_date, holiday_region)
        end

        def factory_days_passed(until_date, holiday_region)
          holiday_region = holiday_region ? Array(holiday_region) : nil
          until_date.factory_days_until(self, holiday_region)
        end
      end
    end
  end
end

module ActiveSupport
  module CoreExtensions
    module Time
      module FactoryDays

        def factory_day?(holiday_region=nil)
          holiday_region = holiday_region ? Array(holiday_region) : nil
          if holiday_region
            return true if (1..5).cover?(wday) && Holidays.on(self, *holiday_region, :observed).empty?
          else
            return true if (1..5).cover?(wday) && Holidays.on(self, :observed).empty?
          end
          result = business_weekends(holiday_region)
          result = result && result.include?(self) ? true : false
          return result
        end

        def next_factory_day(options={})
          # options
          # :num_days
          # :holiday_region
          # :check_holiday_start_date_only
          # :secondary_holiday_region

          num_days = options[:num_days] || 1
          holiday_region = options[:holiday_region] ? Array(options[:holiday_region]) : nil
          check_holiday_on_start_date_only = options[:check_holiday_start_date_only] || false
          secondary_holiday_region = options[:secondary_holiday_region]

          day_count = 0
          next_day = self
          while day_count < num_days
            next_day += 1.days
            holiday_region = check_holiday_on_start_date_only ? nil : holiday_region
            if secondary_holiday_region && !check_holiday_on_start_date_only
              holiday_region = secondary_holiday_region
            end
            if next_day.factory_day?(holiday_region)
              day_count += 1
            end
          end
          next_day
        end

        def prev_factory_day(options={})
          # options
          # :num_days
          # :holiday_region

          num_days = options[:num_days] || 1
          holiday_region = options[:holiday_region] ? Array(options[:holiday_region]) : nil

          day_count = 0
          prev_day = self
          while day_count < num_days
            prev_day -= 1.days
            if prev_day.factory_day?(holiday_region)
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