# HebrewDate

`hebrew_date` is a library designed to provide information about the Jewish
calendar. This includes dates, <!---times,---> holidays, and parsha of the week.

<!---
`hebrew_date` depends on the [ruby-sun-times](https://github.com/joeyates/ruby-sun-times)
gem.
--->

Usage
=====

Full documentation can be found [here](http://rawgithub.com/dorner/hebrew_date/master/doc/index.html).

To initialize a Hebrew date, you can use either the English date:

    HebrewDate.new(2009, 12, 25)

or the Hebrew one:

    HebrewDate.new_from_hebrew(5775, 4, 29)

HebrewDates respond to all the methods dates do:

    HebrewDate.new.saturday?
    HebrewDate.new.beginning_of_week # Rails

Printing
========

HebrewDate also responds to ``strftime``, but provides a number of additional
flags for printing Hebrew dates. These are identical to the normal flags
except that they start with * instead of %:

* ``*Y`` - Hebrew year
* ``*m`` - Hebrew month, zero-padded
* ``*_m`` - Hebrew month, blank-padded
* ``*-m`` - Hebrew month, no-padded
* ``*B`` - Hebrew month, full name
* ``*^B`` - Hebrew month, full name uppercase
* ``*b`` - Hebrew month, 3 letters
* ``*^b`` - Hebrew month, 3 letters uppercase
* ``*h`` - same as %*b
* ``*d`` - Hebrew day of month, zero-padded
* ``*-d`` - Hebrew day of month, no-padded
* ``*e`` - Hebrew day of month, blank-padded

Parsha
======

You can get the parsha of the current day by calling the ``parsha`` method.
This will only return a value if it is on Shabbat. By default the parsha
will have "special" values appended to it (e.g. the special Parshiyot,
Shekalim, Zachor, Parah and Hachodesh), which can optionally be suppressed.

By default HebrewDate will use the "chutz la'aretz" parsha scheme (i.e. assuming
two-day Yom Tov). You can use the Israeli scheme by calling

    HebrewDate.israeli = true

before creating your first instance of HebrewDate.

Holiday
=======

If the current date is a Jewish holiday (including Erev Yom Tov and the
"modern" holidays of Yom Ha'atzmaut, Yom Hazikaron and Yom Yerushalayim) you
can retrieve those as strings via the ``holiday`` method.

Month names, holidays and parshiyot all will be in Sephardic / Mizrachi
accents by default. You can change this to Ashkenazi pronunciation by calling

    HebrewDate.ashkenazi = true


