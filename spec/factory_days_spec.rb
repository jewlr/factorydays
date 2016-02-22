require 'spec_helper'

describe FactoryDays do
  describe "method:factoryday?" do
    context "with weekday" do
      it "should return true if weekday is not a holiday" do
        expect(Date.new(2016,2,19).factoryday?).to be true
      end

      it "should return false if weekday is a holiday" do
        expect(Date.new(2016,1,1).factoryday?).to be false
      end
    end

    context "with weekend" do
      it "should return true if weekend is a factory day" do
        expect(Date.new(2016,2,5).factoryday?).to be true
      end

      it "should return false if weekend is not a factory day" do
        expect(Date.new(2016,2,21).factoryday?).to be false
      end
    end
  end

  describe "method:next_factoryday" do
    it "should return the next day as the next day is a weekday" do
      expect(Date.new(2016,2,22).next_factoryday).to eq(Date.new(2016,2,23))
    end

    it "should return a weekday that is 3 days later as the next day is a Saturday" do
      expect(Date.new(2016,2,19).next_factoryday).to eq(Date.new(2016,2,22))
    end

    it "should return a weekday that is 4 days later as the next few days have a holiday and a weekend" do
      expect(Date.new(2016,2,12).next_factoryday).to eq(Date.new(2016,2,16))
    end
  end

  describe "method:prev_factoryday" do
    it "should return the previous day as the previous day is a weekday" do
      expect(Date.new(2016,2,23).prev_factoryday).to eq(Date.new(2016,2,22))
    end

    it "should return a weekday that is 3 days before as the previous day is a Sunday" do
      expect(Date.new(2016,2,22).prev_factoryday).to eq(Date.new(2016,2,19))
    end

    it "should return a weekday that is 4 days before as the previous few days have a weekend and a holiday" do
      expect(Date.new(2016,2,16).prev_factoryday).to eq(Date.new(2016,2,12))
    end
  end

  describe "method:factorydays_untill" do

    it "should return 0 as ending date is before starting date" do
      expect(Date.new(2016,2,29).factorydays_until(Date.new(2016,2,22))).to be 0
    end

    context "with only weekdays and weekends in date range" do
      it "should return 5 days" do
        expect(Date.new(2016,2,22).factorydays_until(Date.new(2016,2,29))).to be 5
      end
    end

    context "with weekdays and factory day weekends in date range" do
      it "it should return 7 days" do
        expect(Date.new(2016,2,1).factorydays_until(Date.new(2016,2,8))).to be 7
      end
    end

    context "with weekdays, factory day weekends, and holidays in date range" do
      it "should return 33 days" do
        expect(Date.new(2016,1,1).factorydays_until(Date.new(2016,2,19))).to be 35
      end
    end
  end

  describe "method:factorydays_passed" do

    it "should return 0 as ending date is after starting date" do
      expect(Date.new(2016,2,22).factorydays_passed(Date.new(2016,2,29))).to be 0
    end

    context "with only weekdays and weekends in date range" do
      it "should return 5 days" do
        expect(Date.new(2016,2,29).factorydays_passed(Date.new(2016,2,22))).to be 5
      end
    end

    context "with weekdays and factory day weekends in date range" do
      it "it should return 7 days" do
        expect(Date.new(2016,2,8).factorydays_passed(Date.new(2016,2,1))).to be 7
      end
    end

    context "with weekdays, factory day weekends, and holidays in date range" do
      it "should return 33 days" do
        expect(Date.new(2016,2,19).factorydays_passed(Date.new(2016,1,1))).to be 35
      end
    end
  end
end
