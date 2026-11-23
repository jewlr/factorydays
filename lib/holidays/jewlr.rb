# encoding: utf-8
module Holidays
  # Jewlr's New Jersey factory calendar.
  module Jewlr # :nodoc:
    def self.defined_regions
      [:jewlr]
    end

    def self.holidays_by_month
      {
        1 => [
          {
            mday: 1,
            observed: lambda do |date|
              Holidays.to_weekday_if_weekend(date)
            end,
            observed_id: 'to_weekday_if_weekend',
            name: "New Year's Day",
            regions: [:jewlr],
          },
        ],
        5 => [
          {
            wday: 1,
            week: -1,
            name: 'Memorial Day',
            regions: [:jewlr],
          },
        ],
        7 => [
          {
            mday: 4,
            observed: lambda do |date|
              Holidays.to_weekday_if_weekend(date)
            end,
            observed_id: 'to_weekday_if_weekend',
            name: 'Independence Day',
            regions: [:jewlr],
          },
        ],
        9 => [
          {
            wday: 1,
            week: 1,
            name: 'Labor Day',
            regions: [:jewlr],
          },
        ],
        11 => [
          {
            wday: 4,
            week: 4,
            name: 'Thanksgiving',
            regions: [:jewlr],
          },
        ],
        12 => [
          {
            mday: 24,
            name: 'Christmas Eve',
            regions: [:jewlr],
          },
          {
            mday: 25,
            observed: lambda do |date|
              Holidays.to_weekday_if_weekend(date)
            end,
            # Lee Fiori and One & Only shipping use the shared ID for Monday observance.
            observed_id: 'jewlr_to_weekday_if_weekend',
            name: 'Christmas Day',
            regions: [:jewlr],
          },
          {
            mday: 31,
            name: "New Year's Eve",
            observed: lambda do |date|
              Holidays.to_friday_if_weekend(date)
            end,
            observed_id: 'to_friday_if_weekend',
            regions: [:jewlr],
          },
        ],
      }
    end
  end
end

Holidays.merge_defs(Holidays::Jewlr.defined_regions, Holidays::Jewlr.holidays_by_month)
