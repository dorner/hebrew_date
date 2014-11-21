require 'date'
require 'delegate'
require_relative 'support/holidays.rb'
require_relative 'support/parshiot.rb'

# This code is essentially a port of Avrom Finkelstein's RegularHebrewDate
# Java class (http://web.archive.org/web/20061207174551/http://www.bayt.org/calendar/hebdate.html)
# which itself implements algorithms presented by Edward M. Reingold and
# Nachum Dershowitz (http://emr.cs.iit.edu/~reingold/calendars.shtml).

# A class that represents a date in both the Gregorian and Hebrew calendars
# simultaneously. Note that you may call any Date methods on this class
# and it should respond accordingly.
class HebrewDate < Delegator
  include Comparable
  include HebrewDateSupport::ParshaMethods
  include HebrewDateSupport::HolidayMethods
  extend HebrewDateSupport::HolidayMethods::ClassMethods

  # @private
  HEBREW_EPOCH = -1373429

  # @private
  HEBREW_MONTH_NAMES = ['Nissan', 'Iyar', 'Sivan', 'Tammuz', 'Av', 'Elul',
                        'Tishrei', 'Cheshvan', 'Kislev', 'Teves', 'Shvat',
                        'Adar', 'Adar II']

  class << self
    # @return [Boolean] Whether to use Ashkenazi pronunciation.
    attr_accessor :ashkenaz

    # @return [Boolean] Whether to use Israeli parsha/holiday scheme.
    attr_accessor :israeli

    # @return [Boolean] If true, replaces "Saturday" or "Sat" in {#strftime}
    #   with "Shabbat" or "Shabbos" depending on the #ashkenaz value.
    attr_accessor :replace_saturday

    # @private
    attr_accessor :debug

  end

  # @return [Integer] the current Gregorian year (e.g. 2008).
  attr_reader :year

  # @return [Integer] the current Gregorian month (1-12).
  attr_reader :month

  # @return [Integer] the current Gregorian day of the month (1-31).
  attr_reader :date

  # @return [Integer] the current Hebrew year (e.g. 5775).
  attr_reader :hebrew_year

  # @return [Integer] the current Hebrew month (1-13).
  attr_reader :hebrew_month

  # @return [Integer] the current Hebrew date (1-30).
  attr_reader :hebrew_date

  # @private
  attr_reader :abs_date

  def initialize(year_or_date_object=nil, month=nil, date=nil)
    @abs_date = 0
    skip_hebrew_date = false
    if year_or_date_object === true
      skip_hebrew_date = true
      year_or_date_object = nil
    end

    if month && date
      @year = year_or_date_object
      @month = month
      @date = date
    else
      date = year_or_date_object || Date.today
      @year = date.year
      @month = date.month
      @date = date.mday
    end
    @israeli = self.class.israeli
    @ashkenaz = self.class.ashkenaz
    @debug = self.class.debug
    set_date(@year, @month, @date) unless skip_hebrew_date
    super(Date.new)
  end

  # @private
  def inspect
    strftime('*Y-*-m-*-d (%Y-%-m-%-d)')
  end

  [:<<, :>>, :gregorian, :england, :italy, :julian, :new_start,
   :next_month, :next_year, :prev_day, :prev_month,
   :prev_year].each do |method_name|
    define_method(method_name) do |*args|
      self.class.new(self.to_date.send(method_name, *args))
    end
  end

  # @private
  def __getobj__
    self.to_date
  end

  # @private
  def __setobj__(obj)
    # do nothing
  end

  # @param other [Fixnum]
  # @return [HebrewDate]
  def +(other)
    date = self.clone
    (1..other).each do |i|
      date.forward
    end
    date
  end

  # @param other [Fixnum]
  # @return [HebrewDate]
  def -(other)
    date = self.clone
    (1..other).each do |i|
      date.back
    end
    date
  end

  # Comparison operator.
  # @param other [HebrewDate]
  # @return [Integer] -1, 0, or 1
  def <=>(other)
    self.to_date <=> other.to_date
  end

  # Iterates evaluation of the given block, which takes a HebrewDate object.
  # The limit should be a Date or HebrewDate object.
  def step(limit, step=1, &block)
    return to_enum(:step, limit, step) unless block_given?
    (self..limit).step(step) { |date| yield(date) }
  end

  # This method is equivalent to step(min, -1){|date| ...}.
  # @param min [Integer]
  # @return [Enumerator|self]
  def downto(min, &block)
    return to_enum(:downto, min) unless block_given?
    self.step(min, -1, &block)
  end

  # This method is equivalent to step(max, 1){ |date| ...}.
  # @param max [Integer]
  # @return [Enumerator|self]
  def upto(max, &block)
    return to_enum(:upto, max) unless block_given?
    self.step(max, 1, &block)
  end

  # Create a HebrewDate with initialized Hebrew date values.
  # @param year [Integer] the Hebrew year (e.g. 5774)
  # @param month [Integer] the Hebrew month (1-13)
  # @param date [Integer] the day of the Hebrew month (1-30)
  def self.new_from_hebrew(year, month, date)
    d = self.new(true)
    @year = 1
    @month = 1
    @date = 1
    d.set_hebrew_date(year, month, date, true)
    d
  end

  # Set the Gregorian date of this HebrewDate.
  # @param year [Integer] the Gregorian year (e.g. 2004)
  # @param month [Integer] the Gregorian month (1-12)
  # @param date [Integer] the Gregorian day of month (1-31)
  # @return [void]
  def set_date(year, month, date)
    # precond should be 1->12 anyways, but just in case...
    return "Illegal value for year: #{year}" if year < 0
    return "Illegal value for month: #{month}" if month > 12 || month < 0
    return "Illegal value for date: #{date}" if date < 0

    # make sure date is a valid date for the given month.
    # If not, set to last day of month
    last_day = last_day_of_month(month)
    date = last_day if date > last_day

    @year = year
    @month = month
    @date = date

		# init the Hebrew date
    @abs_date = _date_to_abs_date(@year, @month, @date)
    _abs_date_to_hebrew_date!
  end

  # Set the Hebrew date.
  # @param year [Integer] the Hebrew year (e.g. 2008)
  # @param month [Integer] the Hebrew month (1-13)
  # @param date [Integer] the Hebrew day of month (1-30)
  # @param auto_set [Boolean] Used internally.
  # @return [void]
  def set_hebrew_date(year, month, date, auto_set=false)
    if auto_set
      @hebrew_year = year
      @hebrew_month = month
      @hebrew_date = date
    end
    return "Illegal value for Hebrew year: #{year}" if year < 0
    if month < 0 || month > last_month_of_hebrew_year
      return "Illegal value for Hebrew month: #{month}"
    end
    return "Illegal value for Hebrew date: #{date}" if date < 0

    # make sure date is valid for this month;
    # otherwise, set to last day of month
    last_day = last_day_of_hebrew_month(month)
    date = last_day if date > last_day

    @hebrew_year = year
    @hebrew_month = month
    @hebrew_date = date

  	# reset gregorian date
    @abs_date =
      _hebrew_date_to_abs_date(@hebrew_year, @hebrew_month, @hebrew_date)
    _abs_date_to_date!

  end

  # Return a Ruby Date corresponding to the Gregorian date.
  # @return [Date]
  def to_date
    Date.new(@year, @month, @date)
  end

  # Move forward one day.
  # @return [HebrewDate] the same HebrewDate object again, for chaining.
  def forward
    # Change Gregorian date
    if @date == last_day_of_month
      if @month == 12
        # last day of year
        @year += 1
        @month = 1
        @date = 1
      else
        @month += 1
        @date = 1
      end
    else
      # if not last day of month
      @date += 1
    end

    # Change Hebrew date
    if @hebrew_date == last_day_of_hebrew_month
      if @hebrew_month == 6
        # last day of Elul (i.e. last day of Hebrew year)
        @hebrew_year += 1
        @hebrew_month += 1
        @hebrew_date = 1
      elsif @hebrew_month == last_month_of_hebrew_year
        # last day of Adar or Adar II
        @hebrew_month = 1
        @hebrew_date = 1
      else
        @hebrew_month += 1
        @hebrew_date = 1
      end
    else
      # not last day of month
      @hebrew_date += 1
    end

    # increment the absolute date
    @abs_date += 1

    self
  end

  # This does not modify the current date, but creates a new one.
  # @return [HebrewDate]
  def next
    self + 1
  end

  alias_method :succ, :next

  # Move back one day.
  # @return [HebrewDate] the same HebrewDate object again, for chaining.
  def back
    # Change Gregorian date
    if @date == 1
      if @month == 1
        @month = 12
        @year -= 1
      else
        @month -= 1
      end

      # change to last day of previous month
      @date = last_day_of_month
    else
      @date -= 1
    end

    # Change Hebrew date
    if @hebrew_date == 1
      if @hebrew_month == 1 # Nisan
        @hebrew_month = last_month_of_hebrew_year
      elsif @hebrew_month == 7 # Rosh Hashana
        @hebrew_year -= 1
        @hebrew_month -= 1
      else
        @hebrew_month -= 1
      end
      @hebrew_date = last_day_of_hebrew_month
    else
      @hebrew_date -= 1
    end

    # Change the absolute date
    @abs_date -= 1

    self
  end

  # Get the name of the current Hebrew month.
  # @return [String]
  def hebrew_month_to_s
    self.class.hebrew_month_to_s(@hebrew_month, @hebrew_year)
  end

  # Get the name of the given Hebrew month.
  # @param month [Integer]
  # @param year [Integer]
  # @return [String]
  def self.hebrew_month_to_s(month, year=nil)
    year ||= self.new.hebrew_year
    if hebrew_leap_year?(year) && month == 12
      'Adar I'
    else
      name = HEBREW_MONTH_NAMES[month - 1]
      if name == 'Teves' && !self.ashkenaz
        name = 'Tevet'
      end
      name
    end
  end

  # @return [Boolean]
  def shabbos?
    self.saturday?
  end

  alias_method :shabbat?, :shabbos?

  # Extend the Date strftime method by replacing Hebrew fields. You can denote
  # Hebrew fields by using the * flag. There is one extra flag, %.b, which
  # adds a period after the 3-letter month name *except* for May.
  # Also note that ::replace_saturday will
  # replace the %A, %^A, %a and %^a flags with Shabbat/Shabbos.
  # Supported flags are:
  #  * *Y - Hebrew year
  #  * *m - Hebrew month, zero-padded
  #  * *_m - Hebrew month, blank-padded
  #  * *-m - Hebrew month, no-padded
  #  * *B - Hebrew month, full name
  #  * *^B - Hebrew month, full name uppercase
  #  * *b - Hebrew month, 3 letters
  #  * *^b - Hebrew month, 3 letters uppercase
  #  * *h - same as %*b
  #  * *d - Hebrew day of month, zero-padded
  #  * *-d - Hebrew day of month, no-padded
  #  * *e - Hebrew day of month, blank-padded
  #  * %.b - Gregorian month, 3 letter name, followed by a period, except for
  #     May
  # @param format [String]
  # @return [String]
  def strftime(format)
    format = format.gsub('*Y', @hebrew_year.to_s)
      .gsub('*m', @hebrew_month.to_s.rjust(2, '0'))
      .gsub('*_m', @hebrew_month.to_s.rjust(2, ' '))
      .gsub('*-m', @hebrew_month.to_s)
      .gsub('*B', hebrew_month_to_s)
      .gsub('*^B', hebrew_month_to_s.upcase)
      .gsub('*b', hebrew_month_to_s[0, 3])
      .gsub('*^b', hebrew_month_to_s[0, 3].upcase)
      .gsub('*h', hebrew_month_to_s[0, 3])
      .gsub('*d', @hebrew_date.to_s.rjust(2, '0'))
      .gsub('*-d', @hebrew_date.to_s)
      .gsub('*e', @hebrew_date.to_s.rjust(2, ' '))
      .gsub('%.b', self.month == 5 ? '%b' : '%b.')
    if self.class.replace_saturday && self.day == 7
      shab_name = self.class.ashkenaz ? 'Shabbos' : 'Shabbat'
      format = format.gsub('%A', shab_name)
        .gsub('%^A', shab_name.upcase)
        .gsub('%a', shab_name[0..2])
        .gsub('%^a', shab_name[0..2].upcase)
    end
    super(format)
  end

  # Get the day of the week.
  # @return [Integer] the day of the week, 1-7.
  def day
    to_date.strftime('%w').to_i + 1
  end

  # The last day of the Gregorian month.
  # @param month [Integer] Used internally.
  # @return [Integer]
  def last_day_of_month(month=nil)
    month ||= @month
    case month
      when 2
        if (((@year.remainder(4)) == 0) && ((@year.remainder(100)) != 0)) ||
          ((@year.remainder(400)) == 0)
          29
        else
          28
        end
      when 4, 6, 9, 11
        30
      else
        31
    end
  end

  class << self
    # Is this a Hebrew leap year?
    # @param year [Integer] the Hebrew year.
    # @return [Boolean]
    def hebrew_leap_year?(year)
      (((7 * year) + 1).remainder(19)) < 7
    end

    # The last month in the Hebrew year (12 or 13).
    # @param year [Integer] the Hebrew year.
    # @return [Integer]
    def last_month_of_hebrew_year(year)
      hebrew_leap_year?(year) ? 13 : 12
    end

    # Get the name of the given day (1-7).
    # @param day [Integer]
    # @return [String]
    def day_name(day)
      if self.replace_saturday && day == 7
        self.ashkenaz ? 'Shabbos' : 'Shabbat'
      else
        Date::DAYNAMES[day - 1]
      end
    end

  end

  # The last month in this Hebrew year (12 or 13).
  # @return [Integer]
  def last_month_of_hebrew_year
    self.class.last_month_of_hebrew_year(@hebrew_year)
  end

  # Is this a Hebrew leap year?
  # @return [Boolean]
  def hebrew_leap_year?
    self.class.hebrew_leap_year?(@hebrew_year)
  end

  # Last day of the current Hebrew month.
  # @param month [Integer] Used internally.
  # @return [Integer]
  def last_day_of_hebrew_month(month=nil)
    month ||= @hebrew_month
    if month == 2 ||
      month == 4 ||
      month == 6 ||
      (month == 8 && !_cheshvan_long?) ||
      (month == 9 && _kislev_short?) ||
      month == 10 ||
      (month == 12 && !hebrew_leap_year?) ||
      month == 13
      29
    else
      30
    end
  end

  private

  # Computes the Gregorian date from the absolute date.
  # @return [void]
  def _abs_date_to_date!
    puts "abs_date_to_date #{@abs_date}" if @debug
    # Search forward year by year from approximate year
		@year = (@abs_date / 366.0).to_i
		@year += 1 while @abs_date >= _date_to_abs_date(@year + 1, 1, 1)

		# Search forward month by month from January
		@month = 1
    @month += 1 while @abs_date >
      _date_to_abs_date(@year, @month, last_day_of_month)
		@date = @abs_date - _date_to_abs_date(@year, @month, 1) + 1
    puts "abs_date_to_date calculated #{@year} #{@month} #{@date}" if @debug
  end

  # @param month [Integer]
  # @param date [Integer]
  # @param year [Integer]
  # @return [Integer]
  def _date_to_abs_date(year, month, date)
    puts "date_to_abs_date #{year} #{month} #{date}" if @debug
    # loop through days in prior months this year
    (1..month - 1).each do |m|
  		date += last_day_of_month(m)
    end
    ret = date + # days this year
      (365 * (year - 1)) + # days in previous years ignoring leap days
      (((year - 1) / 4.0).to_i) -  # Julian leap years before this year
      (((year - 1) / 100.0).to_i) + # minus prior century years
      (((year - 1) / 400.0).to_i) # plus prior years divisible by 400
    puts "date_to_abs_date calculated #{ret.to_i}" if @debug
    ret.to_i
  end

  # @param year [Integer]
  # @return [Integer]
  def _hebrew_calendar_elapsed_days(year)
#    puts "hebrew_calendar_elapsed_days #{year}" if @debug
    months_elapsed =
			(235 * ((year - 1) / 19.0).to_i) + # Months in complete cycles so far
			(12 * ((year - 1).remainder(19))) +			# Regular months in this cycle
			((7 * ((year - 1).remainder(19)) + 1) / 19.0).to_i # Leap months this cycle
    parts_elapsed = 204 + 793 * (months_elapsed.remainder(1080))
    hours_elapsed =
      (5 + 12 * months_elapsed + 793 * (months_elapsed / 1080.0).to_i +
			(parts_elapsed/ 1080.0).to_i)
    conjunction_day = (1 + 29 * months_elapsed + (hours_elapsed / 24.0).to_i)
    conjunction_parts = 1080 * (hours_elapsed.remainder(24)) +
      parts_elapsed.remainder(1080)
    alternative_day = conjunction_day
		if (conjunction_parts >= 19440) || # If new moon is at or after midday,
			(((conjunction_day.remainder(7)) == 2) &&	    # ...or is on a Tuesday...
				(conjunction_parts >= 9924) &&	# at 9 hours, 204 parts or later...
				!self.class.hebrew_leap_year?(year)) ||  # ...of a common year,
			(((conjunction_day.remainder(7)) == 1) &&	 # ...or is on a Monday at...
				(conjunction_parts >= 16789) && # 15 hours, 589 parts or later...
				(self.class.hebrew_leap_year?(year - 1))) # at the end of a leap year
			# Then postpone Rosh HaShanah one day
			alternative_day += 1
    end

    # If Rosh Hashana would occur on Sunday, Wednesday, or Friday
    # then postpone it one more day
    if [0, 3, 5].include?(alternative_day.remainder(7))
      alternative_day += 1
    end
#    puts "hebrew_calendar_elapsed_days calculated #{alternative_day}" if @debug
    alternative_day
  end

  # @return [Integer]
  def _days_in_hebrew_year
    _hebrew_calendar_elapsed_days(@hebrew_year + 1) -
			_hebrew_calendar_elapsed_days(@hebrew_year)
  end

  # @return [Boolean]
  def _cheshvan_long?
    _days_in_hebrew_year % 10 == 5
  end

  # @return [Boolean]
  def _kislev_short?
    _days_in_hebrew_year % 10 == 3
  end

  # @return [void]
  def _abs_date_to_hebrew_date!
    puts "abs_date_to_hebrew_date #{@abs_date}" if @debug
    # Speed this up - most dates will be current, so let's use a value
    # we know about.
    if @abs_date >= 735279
      @hebrew_year = 5770
    else
      # Approximation from below.
      @hebrew_year = ((@abs_date + HEBREW_EPOCH) / 366.0).ceil
    end
    # Search forward for year from the approximation.
    while @abs_date >= _hebrew_date_to_abs_date(@hebrew_year + 1, 7, 1) do
      @hebrew_year += 1
    end
    # Search forward for month from either Tishrei or Nissan.
    if @abs_date < _hebrew_date_to_abs_date(@hebrew_year, 1, 1)
      @hebrew_month = 7 # Start at Tishrei
    else
      @hebrew_month = 1 # Start at Nissan
    end

    while @abs_date > _hebrew_date_to_abs_date(@hebrew_year,
                                               @hebrew_month,
                                               last_day_of_hebrew_month) do
      @hebrew_month += 1
    end
    # Calculate the day by subtraction.
    @hebrew_date = @abs_date -
      _hebrew_date_to_abs_date(@hebrew_year, @hebrew_month, 1) + 1
    puts "_abs_date_to_hebrew_date calculated #{@hebrew_year} #{@hebrew_month} #{@hebrew_date}" if @debug
  end

  # @param month [Integer]
  # @param date [Integer]
  # @param year [Integer]
  # @return [void]
  def _hebrew_date_to_abs_date(year, month, date)
    puts "hebrew_date_to_abs_date #{year} #{month} #{date}" if @debug
  	if month < 7 # Before Tishri, so add days in prior months
  		# this year before and after Nisan.
      (7..last_month_of_hebrew_year).each do |m|
        date += last_day_of_hebrew_month(m)
      end

      (1...month).each do |m|
        date += last_day_of_hebrew_month(m)
      end
    else
      # Add days in prior months this year
      (7...month).each do |m|
        date += last_day_of_hebrew_month(m)
      end
    end
    foo = date + _hebrew_calendar_elapsed_days(year) + # Days in prior years.
      HEBREW_EPOCH # Days elapsed before absolute date 1.
    puts "hebrew_date_to_abs_date calculated #{foo}" if @debug
    foo
  end

end