# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/jewlr.yaml, data/north_america_informal.yaml
  #
  # To use the definitions in this file, load it right after you load the
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/us'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module Jewlrshipping # :nodoc:
    def self.defined_regions
      [:jewlrshipping]
    end

    def self.holidays_by_month
      {
        0 => [
          {
            function: lambda do |year|
              Holidays.easter(year) - 2
            end,
            function_id: 'easter(year)-2',
            name: 'Good Friday',
            regions: [:jewlrshipping],
          },
          {
            function: lambda do |year|
              Holidays.easter(year)
            end,
            function_id: 'easter(year)',
            name: 'Easter Sunday',
            regions: [:jewlrshipping],
          },
        ],
        1 => [
          {
            mday: 1,
            observed: lambda do |date|
              Holidays.to_monday_if_weekend(date)
            end,
            observed_id: 'to_monday_if_weekend',
            name: "New Year's Day",
            regions: [:jewlrshipping],
          },
        ],
        2 => [
          {
            wday: 1,
            week: 3,
            name: 'Family Day',
            regions: [:jewlrshipping],
          },
        ],
        5 => [
          {
            function: lambda do |year|
              Holidays.ca_victoria_day(year)
            end,
            function_id: 'ca_victoria_day(year)',
            name: 'Victoria Day',
            regions: [:jewlrshipping],
          },
        ],
        7 => [
          {
            mday: 1,
            observed: lambda do |date|
              Holidays.to_monday_if_weekend(date)
            end,
            observed_id: 'to_monday_if_weekend',
            name: 'Canada Day',
            regions: [:jewlrshipping],
          },
        ],
        8 => [
          {
            wday: 1,
            week: 1,
            name: 'Civic Holiday',
            regions: [:jewlrshipping],
          },
        ],
        9 => [
          {
            wday: 1,
            week: 1,
            name: 'Labour Day',
            regions: [:jewlrshipping],
          },
          {
            mday: 30,
            name: 'National Day for Truth and Reconciliation',
            observed: lambda do |date|
              Holidays.to_weekday_if_weekend(date)
            end,
            observed_id: 'to_weekday_if_weekend',
            regions: [:jewlrshipping],
          },
        ],
        10 => [
          {
            wday: 1,
            week: 2,
            name: 'Thanksgiving',
            regions: [:jewlrshipping],
          },
        ],
        12 => [
          # Christmas Eve is a valid delivery day
          # {
          #   mday: 24,
          #   observed: lambda do |date|
          #     Holidays.to_friday_if_weekend(date)
          #   end,
          #   observed_id: 'to_friday_if_weekend',
          #   name: 'Christmas Eve',
          #   regions: [:jewlrshipping],
          # },
          {
            mday: 25,
            observed: lambda do |date|
              Holidays.to_monday_if_weekend(date)
            end,
            observed_id: 'to_weekday_if_weekend',
            name: 'Christmas Day',
            regions: [:jewlrshipping],
          },
          {
            mday: 26,
            observed: lambda do |date|
              Holidays.to_weekday_if_boxing_weekend(date)
            end,
            observed_id: 'to_weekday_if_boxing_weekend',
            name: 'Boxing Day',
            regions: [:jewlrshipping],
          },
        ],
      }
    end
  end

  # Monday on or before May 24
  def self.ca_victoria_day(year)
    date = Date.civil(year, 5, 24)
    if date.wday > 1
      date -= (date.wday - 1)
    elsif date.wday.zero?
      date -= 6
    end
    date
  end

  def self.easter(year)
    y = year
    a = y % 19
    b = y / 100
    c = y % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) / 451
    month = (h + l - 7 * m + 114) / 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    Date.civil(year, month, day)
  end
end

Holidays.merge_defs(
  Holidays::Jewlrshipping.defined_regions,
  Holidays::Jewlrshipping.holidays_by_month,
)
