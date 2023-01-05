# frozen_string_literal: true

# require_relative 'factory_days/business_weekends'
require 'active_support/core_ext/integer'
require_relative 'holidays'
require_relative 'factory_off_weekends'
module ActiveSupport
  module CoreExtensions
    module Date
      module FactoryDays
        def factory_day?(options = {})
          # options
          # :holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends
          # :include_factory_day_off
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          weekend_match = (options[:include_weekends] && [0, 6].include?(wday)) ||
                          (options[:include_saturday] && wday == 6) ||
                          (options[:include_sunday] && wday == 0)

          is_factory_day_off = FactoryOffWeekends.factory_off(
            date: self,
            manufacturers: options[:holiday_region],
          )
          begin
            is_holiday = Holidays.on(self, *holiday_region, :observed).any? ||
                         (
                           # For weekend calculations, check if actual is holiday
                           weekend_match && Holidays.on(self, *holiday_region).any?
                         )
          rescue Holidays::UnknownRegionError
            is_holiday = Holidays.on(self, 'jewlr', :observed).any?
          end
          # if factory day off is true we return false no matter what
          if is_factory_day_off == true
            return false
          end
          if !is_holiday && (
               (1..5).cover?(wday) ||
               weekend_match
             )
            return true
          end

          # result = business_weekends(holiday_region)
          # result = result && result.include?(self) ? true : false
          false
        end

        def next_factory_day(options = {})
          # options
          # :num_days
          # :holiday_region
          # :secondary_holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends
          # :factory_day_off

          num_days = options[:num_days] || 1
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          secondary_holiday_region = options[:secondary_holiday_region]

          factory_day_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends],
            include_factory_day_off: options[:factory_day_off],
          }

          day_count = 0
          next_day = self

          # Start Date must be a factory day;
          # this also handles the holiday_region check for the start_date
          next_day += 1.day until next_day.factory_day?(factory_day_params)

          while day_count < num_days
            next_day += 1.days
            factory_day_params[:holiday_region] = secondary_holiday_region || holiday_region
            day_count += 1 if next_day.factory_day?(factory_day_params)
          end
          next_day
        end

        def prev_factory_day(options = {})
          # options
          # :num_days
          # :holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          num_days = options[:num_days] || 1
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          factory_day_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends],
          }

          day_count = 0
          prev_day = self
          prev_day -= 1.day until prev_day.factory_day?(factory_day_params)
          while day_count < num_days
            prev_day -= 1.days
            day_count += 1 if prev_day.factory_day?(factory_day_params)
          end
          prev_day
        end

        def factory_days_until(until_date, options = {})
          # options
          # :holiday_region
          # :secondary_holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          return 0 if self > until_date

          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          secondary_holiday_region = options[:secondary_holiday_region]

          factory_days_until_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends],
          }

          ((self + 1.day)..until_date).count do |date|
            factory_days_until_params[:holiday_region] = secondary_holiday_region || holiday_region
            date.factory_day?(factory_days_until_params)
          end
        end

        def factory_days_passed(until_date, options = {})
          # options
          # :holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends
          options[:holiday_region] = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless options[:holiday_region]

          until_date.factory_days_until(self, options)
        end
      end
    end
  end
end

module ActiveSupport
  module CoreExtensions
    module Time
      module FactoryDays
        def factory_day?(options = {})
          # options
          # :holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          begin
            is_holiday = Holidays.on(self, *holiday_region, :observed).any?
          rescue Holidays::UnknownRegionError
            is_holiday = Holidays.on(self, 'jewlr', :observed).any?
          end

          if !is_holiday && (
               (1..5).cover?(wday) ||
               options[:include_saturday] && wday == 6 ||
               options[:include_sunday] && wday == 0 ||
               options[:include_weekends] && [0, 6].include?(wday)
             )
            return true
          end

          # result = business_weekends(holiday_region)
          # result = result && result.include?(self) ? true : false
          false
        end

        def next_factory_day(options = {})
          # options
          # :num_days
          # :holiday_region
          # :secondary_holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          num_days = options[:num_days] || 1
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          secondary_holiday_region = options[:secondary_holiday_region]

          factory_day_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends],
          }

          day_count = 0
          next_day = self

          # Start Date must be a factory day for holiday region
          next_day += 1.day until next_day.factory_day?(factory_day_params)

          # For subsequent day checks, we will check secondary_holiday_region
          # if passed in
          factory_day_params[:holiday_region] = secondary_holiday_region || holiday_region

          while day_count < num_days
            next_day += 1.days

            day_count += 1 if next_day.factory_day?(factory_day_params)
          end
          next_day
        end

        def prev_factory_day(options={})
          # options
          # :num_days
          # :holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          num_days = options[:num_days] || 1
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          factory_day_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends],
          }

          day_count = 0
          prev_day = self
          while day_count < num_days
            prev_day -= 1.days
            day_count += 1 if prev_day.factory_day?(factory_day_params)
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

# extending time module to support FactoryDays
class Time
  include ActiveSupport::CoreExtensions::Time::FactoryDays
end
