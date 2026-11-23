# frozen_string_literal: true

module Holidays
  # Jewlr's New Jersey pickup calendar uses actual dates for fixed-date holidays.
  module Jewlrshipping # :nodoc:
    def self.defined_regions
      [:jewlrshipping]
    end

    def self.holidays_by_month
      {
        1 => [
          {
            mday: 1,
            name: "New Year's Day",
            regions: [:jewlrshipping],
          },
          {
            wday: 1,
            week: 3,
            name: 'Martin Luther King, Jr. Day',
            regions: [:jewlrshipping],
          },
        ],
        5 => [
          {
            wday: 1,
            week: -1,
            name: 'Memorial Day',
            regions: [:jewlrshipping],
          },
        ],
        7 => [
          {
            mday: 4,
            name: 'Independence Day',
            regions: [:jewlrshipping],
          },
        ],
        9 => [
          {
            wday: 1,
            week: 1,
            name: 'Labor Day',
            regions: [:jewlrshipping],
          },
        ],
        11 => [
          {
            wday: 4,
            week: 4,
            name: 'Thanksgiving',
            regions: [:jewlrshipping],
          },
        ],
        12 => [
          {
            mday: 25,
            name: 'Christmas Day',
            regions: [:jewlrshipping],
          },
        ],
      }
    end
  end
end

Holidays.merge_defs(
  Holidays::Jewlrshipping.defined_regions,
  Holidays::Jewlrshipping.holidays_by_month,
)
