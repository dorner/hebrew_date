module HebrewDateSupport
  module Times

    # Get the sunrise time, in UTC, for this date.
    # @return [Time]
    def sunrise
      self.suntimes(90.83333)[0]
    end

    # Get the sunset time, in UTC, for this date.
    # @return [Time]
    def sunset
      self.suntimes(90.83333)[1]
    end

    # Get the candle lighting time, in UTC. Nil if today is not a candle
    # lighting day.
    # @return [Time]
    def candle_lighting
      return nil unless self.candle_lighting_day?
      self.sunset - (@config.candle_lighting_offset * 60)
    end

    # Get the havdala time, in UTC. Nil if today is not a havdala day.
    # @return [Time]
    def havdala
      return nil unless self.havdala_day?
      self.sunset + (@config.havdala_offset * 60)
    end

    # Get the misheyakir time in UTC, based on the number of degrees configured.
    # @return [Time]
    def misheyakir
      self.suntimes(90 + @config.misheyakir_degrees)[0]
    end

    # Based on https://github.com/sevrinsky/shul-calendar/blob/master/Suntimes.pm
    # @return [Array<Time>] sunrise and sunset times.
    def suntimes(degrees)
      day_of_year = self.to_date.yday
      a = 1.5708
      b = 3.14159
      c = 4.71239
      d = 6.28319
      e = 0.0174533 * @config.latitude
      f = 0.0174533 * @config.longitude
      g = 0 # timezone offset
      r = Math.cos(0.01745 * degrees)
      j = sr = ss = nil

      # false for sunrise, true for sunset
      [false, true].each do |i|
        j = i ? c : a
        k = day_of_year + ((j - f) / d)
        l = (k * 0.017202) - 0.0574039
        m = l + 0.0334405 * Math.sin(l)
        m += 4.93289 + (3.49066E-04) * Math.sin(2 * l)

        if d == 0
          raise 'Trying to normalize with zero offset'
        end

        while m < 0
          m += d
        end

        while m >= d
          m -= d
        end

        if (m / a) - ((m / a).floor) == 0
          m += 4.84814E-06
        end

        p = Math.sin(m) / Math.cos(m)
        p = Math.atan2(0.91746 * p, 1)

        if m > c
          p += d
        elsif m > a
          p += b
        end

        q = 0.39782 * Math.sin(m)
        q = q / Math.sqrt(-q * q + 1)
        q = Math.atan2(q, 1)

        s = r - (Math.sin(q) * Math.sin(e))
        s = s / (Math.cos(q) * Math.cos(e))

        if s.abs > 1
          return nil
        end

        s = s / Math.sqrt(-s * s + 1)
        s = a - Math.atan2(s, 1)

        unless i
          s = d - s
        end

        t = s + p - 0.0172028 * k - 1.73364
        u = t - f
        v = u + g

        if d == 0
          raise 'Trying to normalize with zero offset'
        end

        while v < 0
          v = v + d
        end

        while v >= d
          v = v - d
        end

        v = v * 3.81972
        if i
          ss = v
        else
          sr = v
        end
      end
      [sr, ss].map do |time|
        hour = time.floor
        min = ((time - hour) * 60 + 0.5).floor
        if min >= 60
          min -= 60
          hour -= 1
        end
        if hour < 0
          hour += 12
        end
        Time.new(self.year, self.month, self.day, hour, min)
      end
    end

  end
end