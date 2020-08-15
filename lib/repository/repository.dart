// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/models/daily_stats.dart';
import 'package:covid_tracker/models/models.dart';
import 'package:covid_tracker/utils/utils.dart';

class Repository {
  APIClient apiClient;

  Repository(this.apiClient);

  Future<ResponseResult<Stats>> getGlobalStats() async {
    try {
      final result = await apiClient.dio
          .get('${STAT_URL}free-api', queryParameters: {'global': 'stats'});
      if (result.statusCode == 200) {
        return ResponseResult(
            data: Stats.fromJson(result.data['results'].first));
      }
      return ResponseResult.fromError(result.statusMessage);
    } catch (error) {
      logger.v('Error - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<Stats>> getCountryStats(String country) async {
    try {
      final result = await apiClient.dio.get('${STAT_URL}free-api',
          queryParameters: {'countryTotal': country});
      if (result.statusCode == 200) {
        return ResponseResult(
            data: Stats.fromJson(result.data['countrydata'].first));
      }
      return ResponseResult.fromError(result.statusMessage);
    } catch (error) {
      logger.v('Error - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<List<DailyStats>>> getGlobalTimeline() async {
    try {
      final result = await apiClient.dio.get('${TIMELINE_URL}global/count');
      if (result.statusCode == 200) {
        return ResponseResult(
            data: List<DailyStats>.from(result.data['result'].entries
                .map((element) => DailyStats.fromJson(element))));
      }
      return ResponseResult.fromError(result.statusMessage);
    } catch (error) {
      logger.v('Error - $error');
      return ResponseResult.fromError(error);
    }
  }

  Future<ResponseResult<List<DailyStats>>> getCountryTimeline(
      String countryCode3) async {
    try {
      final result =
          await apiClient.dio.get('${TIMELINE_URL}country/$countryCode3');
      if (result.statusCode == 200) {
        return ResponseResult(
            data: List<DailyStats>.from(result.data['result']
                .map((element) => DailyStats.fromJson(element))));
      }
      return ResponseResult.fromError(result.statusMessage);
    } catch (error) {
      logger.v('Error - $error');
      return ResponseResult.fromError(error);
    }
  }
}
