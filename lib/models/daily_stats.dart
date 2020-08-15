class DailyStats {
  DailyStats({
    this.date,
    this.cases,
    this.deaths,
    this.recovered,
  });

  String date;
  int cases;
  int deaths;
  int recovered;

  factory DailyStats.fromJson(MapEntry<String, dynamic> json) => DailyStats(
        date: json.key,
        cases: json.value['confirmed'],
        deaths: json.value['deaths'],
        recovered: json.value['recovered'],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "cases": cases,
        "deaths": deaths,
        "recovered": recovered,
      };
}
