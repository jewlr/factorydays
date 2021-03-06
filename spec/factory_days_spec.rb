# frozen_string_literal: true

require 'spec_helper'

describe FactoryDays do
  describe 'factory_day?' do
    it 'should require holiday_region' do
      expect { Date.new(2020, 9, 14).factory_day? }.to raise_error(ArgumentError)
    end

    it 'should identify Family Day as a holiday' do
      expect(
        Date.new(2020, 2, 17).factory_day?(
          holiday_region: [:jewlr],
        ),
      ).to be_falsey
    end
  end

  describe 'next_factory_day' do
    it 'should calculate Sept 14 2020 + 3 biz days to be Sept 17 2020' do
      expect(
        Date.new(2020, 9, 14).next_factory_day(
          holiday_region: :jewlrshipping,
          num_days: 3,
        ),
      ).to eq(Date.new(2020, 9, 17))
    end

    context 'check_holiday_start_date_only: true' do
      context 'with :us region previously loaded' do
        it 'should calculate Sept 14 2020 + 1 biz day to be Sept 15 2020' do
          # Random next factory day to try and "accidentally load" north_america
          # which won't happen any more
          Date.new(2020, 9, 14).next_factory_day(holiday_region: [:us])

          expect(
            Date.new(2020, 9, 14).next_factory_day(
              check_holiday_start_date_only: true,
              holiday_region: [:jewlrshipping],
              include_saturday: false,
              include_sunday: false,
              include_weekends: nil,
              num_days: 1,
              secondary_holiday_region: :us,
            ),
          ).to eq(Date.new(2020, 9, 15))
        end
      end

      context 'with :au region previously loaded' do
        it 'should calculate Apr 24 2020 + 1 biz day to be Apr 27 2020' do
          # Random next factory day to load :au which contains
          # ANZAC Day in Australia for Apr 27th 2020 (following Monday)
          Date.new(2020, 2, 17).next_factory_day(holiday_region: [:au])

          expect(
            Date.new(2020, 4, 24).next_factory_day(
              check_holiday_start_date_only: true,
              holiday_region: [:jewlrshipping],
              include_saturday: false,
              include_sunday: false,
              include_weekends: nil,
              num_days: 1,
              # What is SUPPOSED to happen is that the secondary_holiday_region
              # is used in the factory_day? calls. If this doesn't happen, then
              # there is a failure
              secondary_holiday_region: :us,
            ),
          ).to eq(Date.new(2020, 4, 27))
        end
      end
    end
  end
end

# describe FactoryDays do
#   describe 'method:factory_day?' do
#     context 'with weekday' do
#       it 'should return true if weekday is not a holiday (jewlr)' do
#         expect(Date.new(2016,2,19).factory_day?(:jewlr)).to be true
#       end

#       it 'should return true if weekday is not a holiday (bogarz)' do
#         expect(Date.new(2016,2,19).factory_day?(:bogarz)).to be true
#       end

#       it 'should return false if weekday is a holiday (jewlr)' do
#         expect(Date.new(2016,2,15).factory_day?(:jewlr)).to be false
#       end

#       it 'should return false if weekday is a holiday (bograz)' do
#         expect(Date.new(2016,1,1).factory_day?(:bogarz)).to be false
#       end
#     end

#     context 'with weekend' do
#       it 'should return true if weekend is a factory day (jewlr)' do
#         expect(Date.new(2016,2,5).factory_day?(:jewlr)).to be true
#       end

#       it 'should return true if weekend is a factory day (bogarz)' do
#         expect(Date.new(2016,2,13).factory_day?(:bogarz)).to be true
#       end

#       it 'should return false if weekend is not a factory day (jewlr)' do
#         expect(Date.new(2016,2,21).factory_day?(:jewlr)).to be false
#       end

#       it 'should return false if weekend is not a factory day (bogarz)' do
#         expect(Date.new(2016,2,21).factory_day?(:bogarz)).to be false
#       end
#     end
#   end

#   describe 'method:next_factory_day' do
#     it 'should return the next day as the next day is a weekday (jewlr)' do
#       expect(Date.new(2016,2,22).next_factory_day(:jewlr)).to eq(Date.new(2016,2,23))
#     end

#     it 'should return a weekday that is 3 days later as the next day is a Saturday (jewlr)' do
#       expect(Date.new(2016,2,19).next_factory_day(:jewlr)).to eq(Date.new(2016,2,22))
#     end

#     it 'should return a weekday that is 4 days later as the next few days have a holiday and a weekend (jewlr)' do
#       expect(Date.new(2016,2,12).next_factory_day(:jewlr)).to eq(Date.new(2016,2,16))
#     end

#     it 'should return the next day as the next day is a weekday (bogarz)' do
#       expect(Date.new(2016,2,22).next_factory_day(:bogarz)).to eq(Date.new(2016,2,23))
#     end

#     it 'should return a weekday that is 3 days later as the next day is a Saturday (bogarz)' do
#       expect(Date.new(2016,2,19).next_factory_day(:bogarz)).to eq(Date.new(2016,2,22))
#     end
#   end

#   describe 'method:prev_factory_day' do
#     it 'should return the previous day as the previous day is a weekday (jewlr)' do
#       expect(Date.new(2016,2,23).prev_factory_day(:jewlr)).to eq(Date.new(2016,2,22))
#     end

#     it 'should return a weekday that is 3 days before as the previous day is a Sunday (jewlr)' do
#       expect(Date.new(2016,2,22).prev_factory_day(:jewlr)).to eq(Date.new(2016,2,19))
#     end

#     it 'should return a weekday that is 4 days before as the previous few days have a weekend and a holiday (jewlr)' do
#       expect(Date.new(2016,2,16).prev_factory_day(:jewlr)).to eq(Date.new(2016,2,12))
#     end

#     it 'should return the previous day as the previosu day is a weekday (bogarz)' do
#       expect(Date.new(2016,2,23).prev_factory_day(:bogarz)).to eq(Date.new(2016,2,22))
#     end

#     it 'should return a weekday that is 3 days before as the previous day is a Sunday (bogarz)' do
#       expect(Date.new(2016,2,22).prev_factory_day(:bogarz)).to eq(Date.new(2016,2,19))
#     end
#   end

#   describe 'method:factory_days_until' do

#     it 'should return 0 as ending date is before starting date (applies to jewlr and bogarz)' do
#       expect(Date.new(2016,2,29).factory_days_until(Date.new(2016,2,22), :jewlr, :bogarz)).to be 0
#     end

#     context 'with only weekdays and weekends in date range(applies to jewlr and bogarz)' do
#       it 'should return 5 days' do
#         expect(Date.new(2016,2,22).factory_days_until(Date.new(2016,2,29), :jewlr, :bogarz)).to be 5
#       end
#     end

#     context 'with weekdays and factory day weekends in date range' do
#       it 'it should return 7 days (jewlr)' do
#         expect(Date.new(2016,2,1).factory_days_until(Date.new(2016,2,8), :jewlr)).to be 7
#       end

#       it 'it should return 7 days (bogarz)' do
#         expect(Date.new(2016,2,8).factory_days_until(Date.new(2016,2,15), :bogarz)).to be 7
#       end
#     end

#     context 'with weekdays, factory day weekends, and holidays in date range' do
#       it 'should return 35 days for jewlr' do
#         expect(Date.new(2016,1,1).factory_days_until(Date.new(2016,2,19), :jewlr)).to be 35
#       end

#       it 'should return 36 days for bogarz' do
#         expect(Date.new(2016,1,1).factory_days_until(Date.new(2016,2,19), :bogarz)).to be 36
#       end

#       it 'should return 36 days for jewlr and bogarz' do
#         expect(Date.new(2016,1,1).factory_days_until(Date.new(2016,2,19), :jewlr, :bogarz)).to be 36
#       end
#     end
#   end

#   describe 'method:factory_days_passed' do

#     it 'should return 0 as ending date is after starting date (applies to jewlr and bogarz)' do
#       expect(Date.new(2016,2,22).factory_days_passed(Date.new(2016,2,29), :jewlr, :bogarz)).to be 0
#     end

#     context 'with only weekdays and weekends in date range (applies to jewlr and bogarz)' do
#       it 'should return 5 days' do
#         expect(Date.new(2016,2,29).factory_days_passed(Date.new(2016,2,22), :jewlr, :bogarz)).to be 5
#       end
#     end

#     context 'with weekdays and factory day weekends in date range' do
#       it 'it should return 7 days (jewlr)' do
#         expect(Date.new(2016,2,8).factory_days_passed(Date.new(2016,2,1), :jewlr)).to be 7
#       end

#       it 'it should return 7 days (bogarz)' do
#         expect(Date.new(2016,2,15).factory_days_passed(Date.new(2016,2,8), :bogarz)).to be 7
#       end
#     end

#     context 'with weekdays, factory day weekends, and holidays in date range' do
#       it 'should return 35 days for jewlr' do
#         expect(Date.new(2016,2,19).factory_days_passed(Date.new(2016,1,1), :jewlr)).to be 35
#       end

#       it 'should return 36 days for bogarz' do
#         expect(Date.new(2016,2,19).factory_days_passed(Date.new(2016,1,1), :bogarz)).to be 36
#       end

#       it 'should return 36 days for jewlr and bogarz' do
#         expect(Date.new(2016,2,19).factory_days_passed(Date.new(2016,1,1), :jewlr, :bogarz)).to be 36
#       end
#     end
#   end
# end
