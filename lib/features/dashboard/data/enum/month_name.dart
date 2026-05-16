enum MonthName {
  jan('Jan'),
  feb('Feb'),
  mar('Mar'),
  apr('Apr'),
  may('May'),
  jun('Jun'),
  jul('Jul'),
  aug('Aug'),
  sep('Sep'),
  oct('Oct'),
  nov('Nov'),
  dec('Dec');

  final String shortName;

  const MonthName(this.shortName);

  static String fromMonthNumber(int month) {
    if (month < 1 || month > 12) return '';

    return MonthName.values[month - 1].shortName;
  }
}
