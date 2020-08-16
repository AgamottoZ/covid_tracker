import 'package:covid_tracker/injection.dart';
import 'package:covid_tracker/models/daily_stats.dart';
import 'package:covid_tracker/models/models.dart';
import 'package:covid_tracker/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final repository = getIt.get<Repository>();

  final BehaviorSubject _statSubject = BehaviorSubject<Stats>();

  Stream get statStream => _statSubject.stream;

  final BehaviorSubject _timelineSubject = BehaviorSubject<List<DailyStats>>();

  Stream get timelineStream => _timelineSubject.stream;

  dispose() {
    _statSubject.close();
    _timelineSubject.close();
  }

  Future getGlobalStats() async {
    _statSubject.add(null);
    return repository.getGlobalStats()
      ..then((data) => _statSubject.add(data.data));
  }

  Future getCountryStats(String countryCode) async {
    _statSubject.add(null);
    return repository.getCountryStats(countryCode)
      ..then((data) => _statSubject.add(data.data));
  }

  Future getGlobalTimeline() async {
    _timelineSubject.add(null);
    return repository.getGlobalTimeline()
      ..then((data) => _timelineSubject.add(data.data));
  }

  Future getCountryTimeline(String countryCode3) async {
    _timelineSubject.add(null);
    return repository.getCountryTimeline(countryCode3)
      ..then((data) => _timelineSubject.add(data.data));
  }

  Future<ResponseResult<List<Tip>>> getHomeTips() async {
    return repository.getHomeTips();
  }
}
