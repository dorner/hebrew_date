require_relative '../lib/hebrew_date'

def check_date(hebrew_year, hebrew_month, hebrew_date, year, month, date)
  HebrewDate.new_from_hebrew(hebrew_year, hebrew_month, hebrew_date).to_date.should ==
    Date.new(year, month, date)
end

describe HebrewDate do

  specify 'Hebrew date calendar confirmation' do
    check_date(5773, 1, 1, 2013, 3, 12)
    check_date(5773, 2, 14, 2013, 4, 24)
    check_date(5773, 5, 1, 2013, 7, 8)
    check_date(5773, 6, 29, 2013, 9, 4)
    check_date(5774, 7, 1, 2013, 9, 5)
    check_date(5774, 12, 1, 2014, 2, 1)
    check_date(5774, 12, 30, 2014, 3, 2)
    check_date(5774, 13, 1, 2014, 3, 3)
    check_date(5774, 1, 1, 2014, 4, 1)
  end

  specify 'parshiot' do
    HebrewDate.new(2014, 1, 1).parsha.should be_nil
    HebrewDate.new(2014, 1, 4).parsha.should == 'Bo'
    HebrewDate.new(2014, 3, 1).parsha.should == 'Pekudei/Shekalim'
    HebrewDate.new(2014, 3, 15).parsha.should == 'Tzav/Zachor'
    HebrewDate.new(2014, 3, 22).parsha.should == 'Shmini/Parah'
    HebrewDate.new(2014, 3, 29).parsha.should == 'Tazria/Hachodesh'
    HebrewDate.new(2014, 3, 19).parsha.should be_nil
    HebrewDate.new(2001, 1, 6).parsha.should == 'Vayigash'
    HebrewDate.new(2001, 4, 14).parsha.should be_nil
  end

  specify 'holidays' do
    HebrewDate.new(2014, 2, 14).holiday.should == 'Purim Katan'
    HebrewDate.new(2014, 3, 13).holiday.should == "Ta'anit Esther"
    HebrewDate.new(2014, 3, 16).holiday.should == 'Purim'
    HebrewDate.new(2014, 4, 15).holiday.should == 'Pesach'
    HebrewDate.new(2014, 4, 22).holiday.should == 'Pesach'
    HebrewDate.new(2014, 5, 6).holiday.should == "Yom Ha'atzmaut"
    HebrewDate.new(2014, 6, 3).holiday.should == 'Erev Shavuot'
    HebrewDate.new(2014, 7, 15).holiday.should == 'Tzom Tammuz'
    HebrewDate.new(2014, 9, 25).holiday.should == 'Rosh Hashanah'
    HebrewDate.new(2014, 9, 26).holiday.should == 'Rosh Hashanah'
    HebrewDate.new(2014, 12, 15).holiday.should be_nil
    HebrewDate.new(2014, 12, 16).holiday.should == 'Erev Chanukah'
    HebrewDate.new(2014, 12, 17).holiday.should == 'Chanukah'
    HebrewDate.new(2014, 12, 25).holiday.should be_nil
  end

  specify 'from holidays' do
    HebrewDate.from_holiday(:ROSH_HASHANA, 5774).to_date.
      should == Date.new(2013, 9, 5)
    HebrewDate.from_holiday(:TZOM_GEDALIA, 5774).to_date.
      should == Date.new(2013, 9, 8)
    HebrewDate.from_holiday(:YOM_KIPPUR, 5774).to_date.
      should == Date.new(2013, 9, 14)
    HebrewDate.from_holiday(:SUKKOT, 5774).to_date.
      should == Date.new(2013, 9, 19)
    HebrewDate.from_holiday(:SHMINI_ATZERET, 5774).to_date.
      should == Date.new(2013, 9, 26)
    HebrewDate.from_holiday(:CHANUKAH, 5774).to_date.
      should == Date.new(2013, 11, 28)
    HebrewDate.from_holiday(:TZOM_TEVET, 5774).to_date.
      should == Date.new(2013, 12, 13)
    HebrewDate.from_holiday(:TU_BISHVAT, 5774).to_date.
      should == Date.new(2014, 1, 16)
    HebrewDate.from_holiday(:PURIM_KATAN, 5774).to_date.
      should == Date.new(2014, 2, 14)
    HebrewDate.from_holiday(:TAANIT_ESTHER, 5774).to_date.
      should == Date.new(2014, 3, 13)
    HebrewDate.from_holiday(:PURIM, 5774).to_date.
      should == Date.new(2014, 3, 16)
    HebrewDate.from_holiday(:EREV_PESACH, 5774).to_date.
      should == Date.new(2014, 4, 14)
    HebrewDate.from_holiday(:PESACH, 5774).to_date.
      should == Date.new(2014, 4, 15)
    HebrewDate.from_holiday(:PESACH_2, 5774).to_date.
      should == Date.new(2014, 4, 21)
    HebrewDate.from_holiday(:YOM_HAZIKARON, 5774).to_date.
      should == Date.new(2014, 5, 5)
    HebrewDate.from_holiday(:YOM_HAATZMAUT, 5774).to_date.
      should == Date.new(2014, 5, 6)
    HebrewDate.from_holiday(:LAG_BAOMER, 5774).to_date.
      should == Date.new(2014, 5, 18)
    HebrewDate.from_holiday(:YOM_YERUSHALAYIM, 5774).to_date.
      should == Date.new(2014, 5, 28)
    HebrewDate.from_holiday(:SHAVUOT, 5774).to_date.
      should == Date.new(2014, 6, 4)
    HebrewDate.from_holiday(:TZOM_TAMMUZ, 5774).to_date.
      should == Date.new(2014, 7, 15)
    HebrewDate.from_holiday(:TISHA_BAV, 5774).to_date.
      should == Date.new(2014, 8, 5)
  end
end