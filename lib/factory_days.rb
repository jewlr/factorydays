require_relative "factory_days/version"
require_relative "factory_days/factory_days"
require_relative "holidays"

module FactoryDays
  def factoryday?
  end

  def next_factoryday
  end

  def prev_factoryday
  end

  def factorydays_until
  end

  def factorydays_passed
  end
end


class Date
  include FactoryDays
end

class Time
  include FactoryDays
end
