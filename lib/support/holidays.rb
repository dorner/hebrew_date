module HebrewDateSupport
  module HolidayMethods
    module ClassMethods

      # A list of holidays which can be passed into the from_holiday method.
      HOLIDAYS = [
        :TAANIT_BECHORIM,
        :EREV_PESACH,
        :PESACH,
        :PESACH_2,
        :PESACH_SHENI,
        :YOM_HAATZMAUT,
        :YOM_HAZIKARON,
        :YOM_YERUSHALAYIM,
        :LAG_BAOMER,
        :EREV_SHAVUOT,
        :SHAVUOT,
        :TZOM_TAMMUZ,
        :TISHA_BAV,
        :TU_BAV,
        :EREV_ROSH_HASHANA,
        :ROSH_HASHANA,
        :TZOM_GEDALIA,
        :EREV_YOM_KIPPUR,
        :YOM_KIPPUR,
        :EREV_SUKKOT,
        :SUKKOT,
        :SHMINI_ATZERET,
        :SIMCHAT_TORAH,
        :EREV_CHANUKAH,
        :CHANUKAH,
        :TZOM_TEVET,
        :TU_BISHVAT,
        :PURIM_KATAN,
        :TAANIT_ESTHER,
        :PURIM,
        :SHUSHAN_PURIM
      ]

      # Given a holiday name, return a HebrewDate representing that holiday.
      # @param holiday [Symbol] the name of the holiday. Possible values are
      #   in the HOLIDAYS array.
      # @param year [Integer] if given, the Hebrew year to search. Defaults
      #   to the current year.
      def from_holiday(holiday, year=nil)
        year ||= self.new.hebrew_year
        case holiday
          when :TAANIT_BECHORIM
            date = self.from_holiday(:EREV_PESACH, year)
            date.shabbos? ? date - 2 : date
          when :EREV_PESACH
            self.new_from_hebrew(year, 1, 14)
          when :PESACH
            self.new_from_hebrew(year, 1, 15)
          when :PESACH_2
            self.new_from_hebrew(year, 1, 21)
          when :PESACH_SHENI
            self.new_from_hebrew(year, 2, 15)
          when :YOM_HAZIKARON
            self.from_holiday(:YOM_HAATZMAUT).back
          when :YOM_HAATZMAUT
            date = self.new_from_hebrew(year, 2, 5)
            # Friday or Shabbat - move back to Thursday
            # Monday - move forward to Tuesday
            if date.day == 6
              date.back
            elsif date.day == 2
              date.forward
            elsif date.day == 7
              date.set_hebrew_date(year, 2, 3)
            end
          when :LAG_BAOMER
            self.new_from_hebrew(year, 2, 18)
          when :YOM_YERUSHALAYIM
            self.new_from_hebrew(year, 2, 28)
          when :TZOM_TAMMUZ
            date = self.new_from_hebrew(year, 4, 17)
            date.forward if date.day == 7
            date
          when :EREV_SHAVUOT
            self.new_from_hebrew(year, 3, 5)
          when :SHAVUOT
            self.new_from_hebrew(year, 3, 6)
          when :TISHA_BAV
            date = self.new_from_hebrew(year, 5, 9)
            date.forward if date.day == 7
            date
          when :TU_BAV
            self.new_from_hebrew(year, 15, 9)
          when :EREV_ROSH_HASHANA
            self.new_from_hebrew(year, 6, 29)
          when :ROSH_HASHANA
            self.new_from_hebrew(year, 7, 1)
          when :TZOM_GEDALIA
            date = self.new_from_hebrew(year, 7, 3)
            date.forward if date.day == 7
            date
          when :EREV_YOM_KIPPUR
            self.new_from_hebrew(year, 7, 9)
          when :YOM_KIPPUR
            self.new_from_hebrew(year, 7, 10)
          when :EREV_SUKKOT
            self.new_from_hebrew(year, 7, 14)
          when :SUKKOT
            self.new_from_hebrew(year, 7, 15)
          when :SHMINI_ATZERET
            self.new_from_hebrew(year, 7, 22)
          when :SIMCHAT_TORAH
            self.new_from_hebrew(year, 7, 23)
          when :EREV_CHANUKAH
            self.new_from_hebrew(year, 9, 24)
          when :CHANUKAH
            self.new_from_hebrew(year, 9, 25)
          when :TZOM_TEVET
            self.new_from_hebrew(year, 10, 10)
          when :TU_BISHVAT
            self.new_from_hebrew(year, 11, 15)
          when :PURIM_KATAN
            if self.hebrew_leap_year?(year)
              self.new_from_hebrew(year, 12, 14)
            end
          when :TAANIT_ESTHER
            date = self.new_from_hebrew(year,
                                self.last_month_of_hebrew_year(year), 13)
            if date.day == 7
              date.set_hebrew_date(year, date.hebrew_month, 11)
            elsif date.day == 6
              date.back
            end
            date
          when :PURIM
            self.new_from_hebrew(year,
                               self.last_month_of_hebrew_year(year), 14)
          when :SHUSHAN_PURIM
            self.new_from_hebrew(year,
                               self.last_month_of_hebrew_year(year), 15)
        end
      end
    end

    # Returns a string of the Jewish holiday or fast day for the current day,
    # or an empty string if there is no holiday for this day.
    # @param generic [Boolean] whether you want just a generic name
    # (e.g. "Pesach") or a specific one (e.g. "Chol Hamoed Pesach").
    # @return [String]
    def holiday(generic=false)

      # check by month (starts from Nissan)
      case @hebrew_month
        when 1
          if @hebrew_date == 12 && self.thursday?
            return @ashkenaz ? "Ta'anis Bechorim" : "Ta'anit Bechorim"
          end
          return 'Erev Pesach' if @hebrew_date == 14
          if @hebrew_date == 15 || @hebrew_date == 21 ||
            (!@israeli && (@hebrew_date == 16 || @hebrew_date == 22))
            return 'Pesach'
          end
          if @hebrew_date >= 17 && @hebrew_date <= 20 ||
            (@hebrew_date == 16 && @israeli)
            return generic ? 'Pesach' : 'Chol Hamoed Pesach'
          end
        when 2
          return 'Pesach Sheni' if @hebrew_date == 14
          if @hebrew_date == 5 && [1, 3, 4, 5].include?(self.day)
            return "Yom Ha'atzmaut"
          end
          return "Yom Ha'atzmaut" if @hebrew_date == 6 && self.day == 3
          return "Yom Ha'atzmaut" if [3, 4].include?(@hebrew_date) &&
            self.day == 5
          if @hebrew_date == 4 && [2, 3, 4, 7].include?(self.day)
            return 'Yom Hazikaron'
          end
          return 'Yom Hazikaron' if @hebrew_date == 5 && self.day == 2
          return 'Yom Hazikaron' if [2, 3].include?(@hebrew_date) &&
            self.day == 4
          return 'Yom Yerushalayim' if @hebrew_date == 28
        when 3
          if @hebrew_date == 5
            return @ashkenaz ? 'Erev Shavuos' : 'Erev Shavuot'
          end
          if @hebrew_date == 6 || (@hebrew_date == 7 && !@israeli)
            return @ashkenaz ? 'Shavuos' : 'Shavuot'
          end
        when 4
          # push off the fast day if it falls on Shabbos
          if (@hebrew_date == 17 && self.day != 7) ||
            (@hebrew_date == 18 && self.day == 1)
            return 'Tzom Tammuz'
          end
        when 5
          # if Tisha B'Av falls on Shabbos, push off until Sunday
          if (self.day == 1 && @hebrew_date == 10) ||
            (self.day != 7 && @hebrew_date == 9)
            return "Tisha B'av"
          end
          return "Tu B'Av" if @hebrew_date == 15
        when 6
          return 'Erev Rosh Hashanah' if @hebrew_date == 29
        when 7
          return 'Rosh Hashanah' if [1, 2].include?(@hebrew_date)
          # push off Tzom Gedalia if it falls on Shabbos
          if (@hebrew_date == 3 && self.day != 7) ||
            (@hebrew_date == 4 && self.day == 1)
            return 'Tzom Gedalia'
          end
          return 'Erev Yom Kippur' if @hebrew_date == 9
          return 'Yom Kippur' if @hebrew_date == 10
          if @hebrew_date == 14
            return @ashkenaz ? 'Erev Sukkos' : 'Erev Sukkot'
          end
          if @hebrew_date == 15 || (@hebrew_date == 16 && !@israeli)
            return @ashkenaz ? 'Sukkos' : 'Sukkot'
          end
          if @hebrew_date >= 17 && @hebrew_date <= 20 ||
            (@hebrew_date == 16 && @israeli)
            if @ashkenaz
              return generic ? 'Sukkos' : 'Chol Hamoed Sukkos'
            else
              return generic ? 'Sukkot' : 'Chol Hamoed Sukkot'
            end
          end
          return 'Hoshana Rabah' if @hebrew_date == 21
          if @hebrew_date == 22
            return @ashkenaz ? 'Shmini Atzeres' : 'Shmini Atzeret'
          end
          if @hebrew_date == 23 && !@israeli
            return @ashkenaz ? 'Simchas Torah' : 'Simchat Torah'
          end
        when 9
          return 'Erev Chanukah' if @hebrew_date == 24
          return 'Chanukah' if @hebrew_date >= 25
        when 10
          if @hebrew_date == 1 || @hebrew_date == 2 ||
            (@hebrew_date ==3 && _kislev_short?)
            return 'Chanukah'
          end
          if @hebrew_date == 10
            return @ashkenaz ? 'Tzom Teves' : 'Tzom Tevet'
          end
        when 11
          return "Tu B'Shvat" if @hebrew_date == 15
        when 12
          if hebrew_leap_year?
            return 'Purim Katan' if @hebrew_date == 14
          else
            # if 13th Adar falls on Fri or Shabbos, push back to Thursday
            if ((@hebrew_date == 11 || @hebrew_date == 12) && self.day == 5) ||
              (@hebrew_date == 13 && ![6, 7].include?(self.day))
              return @ashkenaz ? "Ta'anis Esther" : "Ta'anit Esther"
            end
            return 'Purim' if @hebrew_date == 14
            return 'Shushan Purim' if @hebrew_date == 15
          end
        when 13
          # if 13th Adar falls on Fri or Shabbos, push back to Thursday
          if ((@hebrew_date == 11 || @hebrew_date == 12) && self.day == 5) ||
            (@hebrew_date == 13 && ![6, 7].include?(self.day))
            return @ashkenaz ? "Ta'anis Esther" : "Ta'anit Esther"
          end
          return 'Purim' if @hebrew_date == 14
          return 'Shushan Purim' if @hebrew_date == 15
        else
          # if we get to this stage, then there are no holidays for the given date
          ''
      end
    end

    # Get the number of the Omer for this day, or nil if there isn't one.
    # @param for_night [Boolean] if true, give the Omer count for the previous
    #  night - i.e. 1 more than the Omer for the current day.
    # @return [Integer]
    def omer(for_night=false)
      for_night_offset = for_night ? 1 : 0
      if for_night && @hebrew_month == 1 && @hebrew_date == 15
        1
      elsif for_night && @hebrew_month == 3 && @hebrew_date == 5
        nil
      elsif @hebrew_month == 1 && @hebrew_date >= 16
        # Nissan, second day of Pesach and on
        @hebrew_date - 15 + for_night_offset
      elsif @hebrew_month == 2 # Iyar
        @hebrew_date + 15 + for_night_offset
      elsif @hebrew_month == 3 && @hebrew_date < 6
        # Sivan, before Shavuos
        @hebrew_date + 44 + for_night_offset
      end
    end

    # Returns the omer day in the form "Omer X" or "Lag B'Omer"
    # or an empty string if there is no omer this day.
    # @return [String]
    def omer_to_s
      omer = self.omer
      if omer.nil?
        ''
      elsif omer == 33
        "Lag B'Omer"
      else
        "Omer #{omer}"
      end
    end

    # Is this date Rosh Chodesh?
    # @return [Boolean]
    def rosh_chodesh?
      @hebrew_date == 1 || @hebrew_date == 30
    end

    # Is this day a first day of Yom Tov? Only should return true if there is
    # a second day.
    # @return [Boolean]
    def first_day_yom_tov?
      # only second day Yom Tov in Israel is Rosh Hashana
      if @israeli
        return @hebrew_month == 7 && @hebrew_date == 1
      end
      case @hebrew_month
        when 7
          # Rosh Hashana, Sukkos, and Shmini Atzeres
          return true if [1, 15, 22].include?(@hebrew_date)
        when 1
          # 2nd and last days Pesach
          return true if [15, 21].include?(@hebrew_date)
        when 3
          # Shavuos
          return true if @hebrew_date == 6
      end
      false
    end

    # Is this a second day of yom tov?
    def second_day_yom_tov?
      # only second day Yom Tov in Israel is Rosh Hashana
      if @israeli
        return @hebrew_month == 7 && @hebrew_date == 2
      end
      case @hebrew_month
        when 7
          # Rosh Hashana, Sukkos, and Shmini Atzeres
          return true if [2, 16, 23].include?(@hebrew_date)
        when 1
          # 2nd and last days Pesach
          return true if [16, 22].include?(@hebrew_date)
        when 3
          # Shavuos
          return true if @hebrew_date == 6
      end
      false
    end

    # Whether there is candle lighting today, i.e.it is either Friday, Erev Yom
    # Tov, or 1st day yom tov when there is a second day.
    # @return [Boolean]
    def candle_lighting_day?
      return true if self.day == 6
      return true if first_day_yom_tov?
      case @hebrew_month
        when 6
          # Erev Rosh Hashana
          return true if @hebrew_date == 29
        when 7
          # Erev Yom Kippur, Erev Sukkos, Erev Shmini Atzeres
          return true if [9, 14, 21].include?(@hebrew_date)
        when 1
          # Erev Pesach or Erev 7th day Pesach
          return true if [14, 20].include?(@hebrew_date)
        when 3
          # Erev Shavuos
          return true if @hebrew_date == 5
      end
      false
    end

    # Whether there is Havdala today. This would be Sat. night (except for a
    # Yom Tov night), or Motzei Yom Tov (except for Fri. night).
    # @return [Boolean]
    def havdala_day?
      # if today is a candlelighting day, then there is no havdala
      return false if candle_lighting_day?

      # if today is Sat. night, return true unless it is Yom Tov
      if self.day == 7
        case @hebrew_month
          when 7
            # 1st day Rosh Hashana
            if @hebrew_date == 1
              false
            else
              # Sukkos 1 and Shmini Atzeres if outside Israel
              @israeli || ![15, 21].include?(@hebrew_date)
            end
          when 1
            # Pesach 1 or 7
            @israeli || ![15, 21].include?(@hebrew_date)
          when 3
            # Shavos 1
            @israeli || @hebrew_date != 6
          else
            true
        end
      else
        # detect Motzai Yom Tov on non-Sat. night
        case @hebrew_month
          when 7
            # Rosh Hashana 2, Yom Kippur, Sukkos, Shmini Atzeres
            [2, 10].include?(@hebrew_date) ||
              (@israeli && [15, 22].include?(@hebrew_date)) ||
              (!@israeli && [16, 23].include?(@hebrew_date))
          when 1
            # Pesach 1/7 or 2/8
            (@israeli && [15, 21].include?(@hebrew_date)) ||
              (!@israeli && [16, 22].include?(@hebrew_date))
          when 3
            # Shavuos
            (@israeli && @hebrew_date == 6) || (!@israeli && @hebrew_date == 7)
          else
            false
        end
      end
    end

  end
end