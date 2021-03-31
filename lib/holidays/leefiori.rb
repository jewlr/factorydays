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
  module Leefiori # :nodoc:
    def self.defined_regions
      [:leefiori]
    end

    def self.holidays_by_month
      {
      0 =>  [
              {:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :name => "Good Friday", :regions => [:leefiori]},
              {:function => lambda { |year| Holidays.easter(year) }, :function_id => "easter(year)", :name => "Easter Sunday", :regions => [:jewlr]},
            ],
      1 =>  [
              {:mday => 1, :observed => lambda { |date| Holidays.to_weekday_if_weekend(date) }, :observed_id => "to_weekday_if_weekend", :name => "New Year's Day", :regions => [:leefiori]}
            ],
      2 =>  [
              {:wday => 1, :week => 3, :name => "Family Day", :regions => [:leefiori]}
            ],
      5 =>  [
              {:function => lambda { |year| Holidays.ca_victoria_day(year) }, :function_id => "ca_victoria_day(year)", :name => "Victoria Day", :regions => [:leefiori]}
            ],
      7 =>  [
              {:mday => 1, :observed => lambda { |date| Holidays.to_monday_if_weekend(date) }, :observed_id => "to_monday_if_weekend", :name => "Canada Day", :regions => [:leefiori]}
            ],
      8 =>  [
              {:wday => 1, :week => 1, :name => "Civic Holiday", :regions => [:leefiori]}
            ],
      9 =>  [
              {:wday => 1, :week => 1, :name => "Labour Day", :regions => [:leefiori]}
            ],
      10 => [
              {:wday => 1, :week => 2, :name => "Thanksgiving", :regions => [:leefiori]}
            ],
      12 => [
              #{:mday => 24, :observed => lambda { |date| Holidays.to_friday_if_weekend(date) }, :observed_id => "to_friday_if_weekend", :name => "Christmas Eve", :regions => [:leefiori]},
              {:mday => 24, :name => "Christmas Eve", :regions => [:leefiori]},
              {:mday => 25, :observed => lambda { |date| Holidays.to_weekday_if_weekend(date) }, :observed_id => "to_weekday_if_weekend", :name => "Christmas Day", :regions => [:leefiori]},
              {:mday => 26, :observed => lambda { |date| Holidays.to_weekday_if_boxing_weekend(date) }, :observed_id => "to_weekday_if_boxing_weekend", :name => "Boxing Day", :regions => [:leefiori]},
              {:mday => 31, :observed => lambda { |date| Holidays.to_friday_if_weekend(date) }, :observed_id => "to_friday_if_weekend", :name => "New Year's Eve", :regions => [:leefiori]}
            ]
      }
    end
  end

  # Monday on or before May 24
  def self.ca_victoria_day(year)
    date = Date.civil(year,5,24)
    if date.wday > 1
      date -= (date.wday - 1)
    elsif date.wday == 0
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

Holidays.merge_defs(Holidays::Leefiori.defined_regions, Holidays::Leefiori.holidays_by_month)
