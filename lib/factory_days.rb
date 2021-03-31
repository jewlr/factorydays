# frozen_string_literal: true

# require_relative 'factory_days/business_weekends'
require 'active_support/core_ext/integer'
require_relative 'holidays'

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
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          is_holiday = Holidays.on(self, *holiday_region, :observed).any?

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
          # :check_holiday_start_date_only
          # :secondary_holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          num_days = options[:num_days] || 1
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          check_holiday_on_start_date_only =
            options[:check_holiday_start_date_only] || false
          secondary_holiday_region = options[:secondary_holiday_region]

          factory_day_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends]
          }

          day_count = 0
          next_day = self

          # Start Date must be a factory day
          next_day += 1.day until next_day.factory_day?(factory_day_params)

          while day_count < num_days
            next_day += 1.days
            holiday_region = if check_holiday_on_start_date_only
                               nil
                             else
                               holiday_region
                             end
            if secondary_holiday_region && !check_holiday_on_start_date_only
              holiday_region = secondary_holiday_region
            end

            factory_day_params[:holiday_region] = holiday_region

            if factory_day_params[:holiday_region].nil? || next_day.factory_day?(factory_day_params)
              day_count += 1
            end
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
            include_weekends: options[:include_weekends]
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
          # :check_holiday_start_date_only
          # :secondary_holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          return 0 if self > until_date

          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          check_holiday_on_start_date_only =
            options[:check_holiday_start_date_only] || false
          secondary_holiday_region = options[:secondary_holiday_region]

          factory_days_until_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends],
          }

          ((self + 1.day)..until_date).count do |date|
            if date != self &&
               secondary_holiday_region &&
               !check_holiday_on_start_date_only
              factory_days_until_params[:holiday_region] = secondary_holiday_region
            end
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

          is_holiday = Holidays.on(self, *holiday_region, :observed).any?
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
          # :check_holiday_start_date_only
          # :secondary_holiday_region
          # :include_saturday
          # :include_sunday
          # :include_weekends

          num_days = options[:num_days] || 1
          holiday_region = Array(options[:holiday_region]) if options[:holiday_region]

          raise 'Missing required :holiday_region option' unless holiday_region

          check_holiday_on_start_date_only =
            options[:check_holiday_start_date_only] || false
          secondary_holiday_region = options[:secondary_holiday_region]

          factory_day_params = {
            holiday_region: holiday_region,
            include_saturday: options[:include_saturday],
            include_sunday: options[:include_sunday],
            include_weekends: options[:include_weekends]
          }

          day_count = 0
          next_day = self

          # Start Date must be a factory day
          next_day += 1.day until next_day.factory_day?(factory_day_params)

          while day_count < num_days
            next_day += 1.days
            holiday_region = if check_holiday_on_start_date_only
                               nil
                             else
                               holiday_region
                             end
            if secondary_holiday_region && !check_holiday_on_start_date_only
              holiday_region = secondary_holiday_region
            end

            factory_day_params[:holiday_region] = holiday_region

            if factory_day_params[:holiday_region].nil? || next_day.factory_day?(factory_day_params)
              day_count += 1
            end
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
            include_weekends: options[:include_weekends]
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
