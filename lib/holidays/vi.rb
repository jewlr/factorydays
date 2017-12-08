# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/vi.yaml
  #
  # To use the definitions in this file, load it right after you load the 
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/vi'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module VI # :nodoc:
    def self.defined_regions
      [:vi]
    end

    def self.holidays_by_month
      {
              1 => [{:mday => 1, :name => "New Year", :regions => [:vi]}],
      4 => [{:mday => 30, :name => "Liberation Day", :regions => [:vi]}],
      5 => [{:mday => 1, :name => "International Workers' Day", :regions => [:vi]}],
      9 => [{:mday => 2, :name => "National Day", :regions => [:vi]}]
      }
    end
  end


end

Holidays.merge_defs(Holidays::VI.defined_regions, Holidays::VI.holidays_by_month)
