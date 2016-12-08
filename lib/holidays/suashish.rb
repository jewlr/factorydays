begin
  require 'google/apis/calendar_v3'
  require 'google/api_client'
rescue LoadError
  raise "Could not load the google-api-client gem.  Use `gem install google-api-client` to install it."
end

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
  module Suashish # :nodoc:
    INDIA_HOLIDAYS_CALENDER_ID = 'en.indian#holiday@group.v.calendar.google.com'
    ACCEPTED_CUSTOM_HOLIDAYS = ['Dolyatra', 'Chaitra Sukhladi', 'Mahavir Jayanti', 'Buddha Purnima/Vesak', 'Rath Yatra', 'Janmashtami', 'Ganesh Chaturthi/Vinayaka Chaturthi', 'Bakr Id/Eid ul-Adha', 'Dussehra', 'Muharram', 'Naraka Chaturdasi', 'Bhai Duj', 'Milad un-Nabi/Id-e-Milad']

    def self.defined_regions
      [:suashish]
    end

    def self.holidays_by_month
      additional_holidays = india_holidays(Date.today.year)
      {
      0 =>  [
              {:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :name => "Good Friday", :regions => [:suashish]}
            ],
      1 =>  [
              {:mday => 1, :observed => lambda { |date| Holidays.to_weekday_if_weekend(date) }, :observed_id => "to_weekday_if_weekend", :name => "New Year's Day", :regions => [:suashish]},
              {:mday => 26, :observed => lambda { |date| Holidays.to_weekday_if_weekend(date) }, :observed_id => "to_weekday_if_weekend", :name => "Republic Day", :regions => [:suashish]}
            ],
      8 =>  [
              {:mday => 15, :observed => lambda { |date| Holidays.to_weekday_if_weekend(date) }, :observed_id => "to_weekday_if_weekend", :name => "Independence Day", :regions => [:suashish]}
            ],
      12 => [
              {:mday => 31, :observed => lambda { |date| Holidays.to_friday_if_weekend(date) }, :observed_id => "to_weekday_if_weekend", :name => "New Year's Eve", :regions => [:suashish]}
            ]
      }.merge(additional_holidays) {|k,a,b| a.push(*b)}
    end

    def self.india_holidays(year)
      key = Google::APIClient::KeyUtils.load_from_pkcs12('Calender-19f407cc399c.p12', 'notasecret')
      client = Google::APIClient.new
      client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :audience => 'https://accounts.google.com/o/oauth2/token',
        :scope => Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
        :issuer => 'calender@calender-151718.iam.gserviceaccount.com',
        :signing_key => key)
      client.authorization.fetch_access_token!

      service = Google::Apis::CalendarV3::CalendarService.new
      service.client_options.application_name = 'Calender'
      token = 'ya29.ElmuA8zZ_2laOJVur78FzWYb_tEtXTg9MuVGQdkVxE2aqZ3juQf7z6s-qV0Og0ZP_rWje_dgbMPNNkcnuV1MGZw2xsq0Fo7FMu_a0NrX5OA9BV64VXcVyO8xCA'
      service.authorization = client.authorization.access_token

      response = service.list_events(INDIA_HOLIDAYS_CALENDER_ID, single_events: true, time_min: Time.new(year).iso8601, time_max: Time.new(year+1).iso8601)

      return response.items.reject{|e| !ACCEPTED_CUSTOM_HOLIDAYS.include?(e.summary)}.group_by{|e| Date.parse(e.start.date || e.start.date_time).month}.inject({}){|h,(g,a)| h.merge g => a.map{|e| {:mday => Date.parse(e.start.date || e.start.date_time).mday, :name => e.summary, :regions => [:suashish]}}}
    end

    private_class_method :india_holidays
  end
end

Holidays.merge_defs(Holidays::Suashish.defined_regions, Holidays::Suashish.holidays_by_month)