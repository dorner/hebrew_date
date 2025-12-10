# frozen_string_literal: true

require_relative '../lib/hebrew_date'

def check_date(hebrew_year, hebrew_month, hebrew_date, year, month, date)
  expect(HebrewDate.new_from_hebrew(hebrew_year, hebrew_month, hebrew_date).to_date).to eq(
    Date.new(year, month, date))
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
    expect(HebrewDate.new(2014, 1, 1).parsha).to be_nil
    expect(HebrewDate.new(2014, 1, 4).parsha).to eq('Bo')
    expect(HebrewDate.new(2014, 3, 1).parsha).to eq('Pekudei/Shekalim')
    expect(HebrewDate.new(2014, 3, 15).parsha).to eq('Tzav/Zachor')
    expect(HebrewDate.new(2014, 3, 22).parsha).to eq('Shmini/Parah')
    expect(HebrewDate.new(2014, 3, 29).parsha).to eq('Tazria/Hachodesh')
    expect(HebrewDate.new(2014, 3, 19).parsha).to be_nil
    expect(HebrewDate.new(2001, 1, 6).parsha).to eq('Vayigash')
    expect(HebrewDate.new(2001, 4, 14).parsha).to be_nil
  end

  specify 'holidays' do
    expect(HebrewDate.new(2014, 2, 14).holiday).to eq('Purim Katan')
    expect(HebrewDate.new(2014, 3, 13).holiday).to eq("Ta'anit Esther")
    expect(HebrewDate.new(2014, 3, 16).holiday).to eq('Purim')
    expect(HebrewDate.new(2014, 4, 15).holiday).to eq('Pesach')
    expect(HebrewDate.new(2014, 4, 22).holiday).to eq('Pesach')
    expect(HebrewDate.new(2014, 5, 6).holiday).to eq("Yom Ha'atzmaut")
    expect(HebrewDate.new(2014, 6, 3).holiday).to eq('Erev Shavuot')
    expect(HebrewDate.new(2014, 7, 15).holiday).to eq('Tzom Tammuz')
    expect(HebrewDate.new(2014, 9, 25).holiday).to eq('Rosh Hashanah')
    expect(HebrewDate.new(2014, 9, 26).holiday).to eq('Rosh Hashanah')
    expect(HebrewDate.new(2014, 12, 15).holiday).to be_nil
    expect(HebrewDate.new(2014, 12, 16).holiday).to eq('Erev Chanukah')
    expect(HebrewDate.new(2014, 12, 17).holiday).to eq('Chanukah')
    expect(HebrewDate.new(2014, 12, 25).holiday).to be_nil
  end

  specify 'from holidays' do
    expect(HebrewDate.from_holiday(:ROSH_HASHANA, 5774).to_date).to eq(Date.new(2013, 9, 5))
    expect(HebrewDate.from_holiday(:TZOM_GEDALIA, 5774).to_date).to eq(Date.new(2013, 9, 8))
    expect(HebrewDate.from_holiday(:YOM_KIPPUR, 5774).to_date).to eq(Date.new(2013, 9, 14))
    expect(HebrewDate.from_holiday(:SUKKOT, 5774).to_date).to eq(Date.new(2013, 9, 19))
    expect(HebrewDate.from_holiday(:SHMINI_ATZERET, 5774).to_date).to eq(Date.new(2013, 9, 26))
    expect(HebrewDate.from_holiday(:CHANUKAH, 5774).to_date).to eq(Date.new(2013, 11, 28))
    expect(HebrewDate.from_holiday(:TZOM_TEVET, 5774).to_date).to eq(Date.new(2013, 12, 13))
    expect(HebrewDate.from_holiday(:TU_BISHVAT, 5774).to_date).to eq(Date.new(2014, 1, 16))
    expect(HebrewDate.from_holiday(:PURIM_KATAN, 5774).to_date).to eq(Date.new(2014, 2, 14))
    expect(HebrewDate.from_holiday(:TAANIT_ESTHER, 5774).to_date).to eq(Date.new(2014, 3, 13))
    expect(HebrewDate.from_holiday(:PURIM, 5774).to_date).to eq(Date.new(2014, 3, 16))
    expect(HebrewDate.from_holiday(:EREV_PESACH, 5774).to_date).to eq(Date.new(2014, 4, 14))
    expect(HebrewDate.from_holiday(:PESACH, 5774).to_date).to eq(Date.new(2014, 4, 15))
    expect(HebrewDate.from_holiday(:PESACH_2, 5774).to_date).to eq(Date.new(2014, 4, 21))
    expect(HebrewDate.from_holiday(:YOM_HAZIKARON, 5774).to_date).to eq(Date.new(2014, 5, 5))
    expect(HebrewDate.from_holiday(:YOM_HAATZMAUT, 5774).to_date).to eq(Date.new(2014, 5, 6))
    expect(HebrewDate.from_holiday(:LAG_BAOMER, 5774).to_date).to eq(Date.new(2014, 5, 18))
    expect(HebrewDate.from_holiday(:YOM_YERUSHALAYIM, 5774).to_date).to eq(Date.new(2014, 5, 28))
    expect(HebrewDate.from_holiday(:SHAVUOT, 5774).to_date).to eq(Date.new(2014, 6, 4))
    expect(HebrewDate.from_holiday(:TZOM_TAMMUZ, 5774).to_date).to eq(Date.new(2014, 7, 15))
    expect(HebrewDate.from_holiday(:TISHA_BAV, 5774).to_date).to eq(Date.new(2014, 8, 5))
  end
end