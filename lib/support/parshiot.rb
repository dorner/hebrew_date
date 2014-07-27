module HebrewDateSupport
  module ParshaMethods
    # Parsha names in Ashkenazi and Sephardi pronunciation.
    # @private
    PARSHA_NAMES          = [
      ['Bereshit', 'Bereishis'],
      ['Noach', 'Noach'],
      ['Lech-Lecha', 'Lech Lecha'],
      ['Vayera', 'Vayeira'],
      ['Chayei Sara', 'Chayei Sarah'],
      ['Toldot', 'Toldos'],
      ['Vayetzei', 'Vayeitzei'],
      ['Vayishlach', 'Vayishlach'],
      ['Vayeshev', 'Vayeishev'],
      ['Miketz', 'Mikeitz'],
      ['Vayigash', 'Vayigash'],
      ['Vayechi', 'Vayechi'],
      ['Shemot', 'Shemos'],
      ['Vaera', "Va'eira"],
      ['Bo', 'Bo'],
      ['Beshalach/Shira', 'Beshalach/Shira'],
      ['Yitro', 'Yisro'],
      ['Mishpatim', 'Mishpatim'],
      ['Terumah', 'Terumah'],
      ['Tetzaveh', 'Tetzaveh'],
      ['Ki Tisa', 'Ki Sisa'],
      ['Vayakhel', 'Vayakhel'],
      ['Pekudei', 'Pekudei'],
      ['Vayikra', 'Vayikra'],
      ['Tzav', 'Tzav'],
      ['Shmini', 'Shemini'],
      ['Tazria', 'Tazria'],
      ['Metzora', 'Metzora'],
      ['Achrei Mot', 'Acharei Mos'],
      ['Kedoshim', 'Kedoshim'],
      ['Emor', 'Emor'],
      ['Behar', 'Behar'],
      ['Bechukotai', 'Bechukosai'],
      ['Bamidbar', 'Bamidbar'],
      ['Nasso', 'Nasso'],
      ["Beha'alotcha", "Beha'aloscha"],
      ["Sh'lach", 'Shelach'],
      ['Korach', 'Korach'],
      ['Chukat', 'Chukas'],
      ['Balak', 'Balak'],
      ['Pinchas', 'Pinchas'],
      ['Matot', 'Mattos'],
      ['Masei', 'Masei'],
      ['Devarim', 'Devarim'],
      ['Vaetchanan', "Va'eschanan"],
      ['Eikev', 'Eikev'],
      ["Re'eh", "Re'eh"],
      ['Shoftim', 'Shoftim'],
      ['Ki Teitzei', 'Ki Seitzei'],
      ['Ki Tavo', 'Ki Savo'],
      ['Nitzavim', 'Nitzavim'],
      ['Vayeilech', 'Vayeilech'],
      ["Ha'Azinu", 'Haazinu'],
      ['Vayakhel-Pekudei', 'Vayakhel-Pekudei'],
      ['Tazria-Metzora', 'Tazria-Metzora'],
      ['Achrei Mot-Kedoshim', 'Acharei Mos-Kedoshim'],
      ['Behar-Bechukotai', 'Behar-Bechukosai'],
      ['Chukat-Balak', 'Chukas-Balak'],
      ['Matot-Masei', 'Mattos-Masei'],
      ['Nitzavim-Vayeilech', 'Nitzavim-Vayeilech']
    ]

    # These indices were originally included in the emacs 19 distribution.
    # These arrays determine the correct indices into the parsha names
    # -1 means no parsha that week, values > 52 means it is a double parsha

    # @private
    SAT_SHORT             =
      [-1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
       11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 53, 23, 24, -1, 25,
       54, 55, 30, 56, 33, 34, 35, 36, 37, 38, 39, 40, 58, 43, 44, 45,
       46, 47, 48, 49, 50]

    # @private
    SAT_LONG              =
      [-1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
       11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 53, 23, 24, -1, 25,
       54, 55, 30, 56, 33, 34, 35, 36, 37, 38, 39, 40, 58, 43, 44,
       45, 46, 47, 48, 49, 59]

    # @private
    MON_SHORT             =
      [51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 53, 23, 24, -1, 25, 54,
       55, 30, 56, 33, 34, 35, 36, 37, 38, 39, 40, 58, 43, 44, 45,
       46, 47, 48, 49, 59]

    # @private
    MON_LONG              = # split
      [51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 53, 23, 24, -1, 25, 54,
       55, 30, 56, 33, -1, 34, 35, 36, 37, 57, 40, 58, 43, 44, 45,
       46, 47, 48, 49, 59]

    # @private
    THU_NORMAL            =
      [52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 53, 23, 24, -1, -1, 25,
       54, 55, 30, 56, 33, 34, 35, 36, 37, 38, 39, 40, 58, 43, 44,
       45, 46, 47, 48, 49, 50]

    # @private
    THU_NORMAL_ISRAEL     =
      [52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 53, 23, 24, -1, 25, 54,
       55, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 58, 43, 44,
       45, 46, 47, 48, 49, 50]

    # @private
    THU_LONG              =
      [52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, -1, 25,
       54, 55, 30, 56, 33, 34, 35, 36, 37, 38, 39, 40, 58, 43, 44,
       45, 46, 47, 48, 49, 50]

    # @private
    SAT_SHORT_LEAP        =
      [-1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
       11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
       26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
       40, 58, 43, 44, 45, 46, 47, 48, 49, 59]

    # @private
    SAT_LONG_LEAP         =
      [-1, 52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
       11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
       26, 27, -1, 28, 29, 30, 31, 32, 33, -1, 34, 35, 36, 37, 57,
       40, 58, 43, 44, 45, 46, 47, 48, 49, 59]

    # @private
    MON_SHORT_LEAP        =
      [51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
       27, -1, 28, 29, 30, 31, 32, 33, -1, 34, 35, 36, 37, 57, 40,
       58, 43, 44, 45, 46, 47, 48, 49, 59]

    # @private
    MON_SHORT_LEAP_ISRAEL =
      [51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
       27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
       58, 43, 44, 45, 46, 47, 48, 49, 59]

    # @private
    MON_LONG_LEAP         =
      [51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
       27, -1, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
       40, 58, 43, 44, 45, 46, 47, 48, 49, 50]
    # @private
    MON_LONG_LEAP_ISRAEL  =
      [51, 52, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
       27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
       41, 42, 43, 44, 45, 46, 47, 48, 49, 50]

    # @private
    THU_SHORT_LEAP        =
      [52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
       27, 28, -1, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
       41, 42, 43, 44, 45, 46, 47, 48, 49, 50]

    # @private
    THU_LONG_LEAP         =
      [52, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
       12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
       27, 28, -1, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
       41, 42, 43, 44, 45, 46, 47, 48, 49, 59]

    # Returns today's parsha(ios) or an empty string if there are none.
    # @param skip_extra [Boolean] if true, do not return "extra" Parsha
    # names such as Zachor or Hagadol.
    # @return [String]
    def parsha(skip_extra=false)
      # if today is not Shabbos, then there is no normal parsha reading
      return nil if self.day != 7

      # kvia= whether a Hebrew year is short/regular/long (0/1/2)
      # rosh_hashana= Rosh Hashana of this Hebrew year
      # rosh_hashana_day= day of week Rosh Hashana was on this year
      # week= current week in Hebrew calendar from Rosh Hashana
      # array= the correct index array for this Hebrew year
      # index= the index number of the parsha name
      array = []
      # create a clone of this date
      rosh_hashana = self.class.new_from_hebrew(@hebrew_year, 7, 1)

      # get day Rosh Hashana was on
      rosh_hashana_day = rosh_hashana.day

      # week is the week since the first Shabbos on or after Rosh Hashana
      week = (((@abs_date - rosh_hashana.abs_date) -
        (7 - rosh_hashana_day)) / 7.0).to_i

      # get kvia
      if _cheshvan_long? && !_kislev_short?
        kvia = 2
      elsif !_cheshvan_long? && _kislev_short?
        kvia = 0
      else
        kvia = 1
      end

      # determine appropriate array
      if hebrew_leap_year?
        # not leap year
        case rosh_hashana_day
          when 7 # RH was on a Sat
            if kvia == 0
              array = SAT_SHORT_LEAP
            elsif kvia == 2
              array = @israeli ? SAT_SHORT_LEAP : SAT_LONG_LEAP
            end
          when 2 # RH was on a Mon
            if kvia == 0
              array = @israeli ? MON_SHORT_LEAP_ISRAEL : MON_SHORT_LEAP
            elsif kvia == 2
              array = @israeli ? MON_LONG_LEAP_ISRAEL : MON_LONG_LEAP
            end
          when 3 # RH was on a Tue
            if kvia == 1
              array = @israeli ? MON_LONG_LEAP_ISRAEL : MON_LONG_LEAP
            end
          when 5 # RH was on a Thu
            if kvia == 0
              array = THU_SHORT_LEAP
            elsif kvia == 2
              array = THU_LONG_LEAP
            end
        end
      else
        case rosh_hashana_day
          when 7 # RH was on a Saturday
            if kvia == 0
              array = SAT_SHORT
            elsif kvia == 2
              array = SAT_LONG
            end
          when 2 # RH was on a Monday
            if kvia == 0
              array = MON_SHORT
            elsif kvia == 2
              array = @israeli ? MON_SHORT : MON_LONG
            end
          when 3 # RH was on a Tuesday
            if kvia == 1
              array = @israeli ? MON_SHORT : MON_LONG
            end
          when 5 # RH was on a Thursday
            if kvia == 1
              array = @israeli ? THU_NORMAL_ISRAEL : THU_NORMAL
            elsif kvia == 2
              array = THU_LONG
            end
        end
      end

      # if something goes wrong
      if array.length == 0
        return 'Was not able to set the index array to any of the known types.'
      end

      # get index from array
      index = array[week]

      # If no Parsha this week
      return nil if index < 0

      # if parsha this week
      subindex     = @ashkenaz ? 1 : 0

      unless skip_extra
        extra_parsha = _extra_parsha
        if extra_parsha
          return "#{PARSHA_NAMES[index][subindex]}/#{extra_parsha}"
        end
      end
      PARSHA_NAMES[index][subindex]
    end

    private

    # Returns any extra information regarding a Shabbos: in particular
    # Shabbos Shuva, Hagadol, and the 4 Parshios
    # (Shekalim, Zachor, Parah, and Hachodesh).
    # @return [String]
    def _extra_parsha
      return if self.day != 7

      adar = last_month_of_hebrew_year

      if @hebrew_month == 1
        return 'Hagadol' if @hebrew_date > 8 && @hebrew_date < 15
        return 'Hachodesh' if @hebrew_date == 1
      end
      return 'Shuva' if @hebrew_month == 7 && @hebrew_date < 10

      # Shekalim is the week before R.C. Adar,
      # unless R.C. Adar falls out on Shabbos.
      return 'Shekalim' if @hebrew_month == adar - 1 && @hebrew_date > 24
      if @hebrew_month == adar
        return 'Shekalim' if @hebrew_date == 1
        return 'Zachor' if @hebrew_date > 7 && @hebrew_date < 14
        return 'Parah' if @hebrew_date > 17 && @hebrew_date < 24
        return 'Hachodesh' if @hebrew_date > 24
      end

      if @hebrew_month == 5
        if @hebrew_date < 9 && @hebrew_date > 2
          return 'Chazon'
        elsif @hebrew_date > 9 && @hebrew_date < 16
          return 'Nachamu'
        end
      end

      nil
    end

  end
end