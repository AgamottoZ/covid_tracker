// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/models/daily_stats.dart';
import 'package:covid_tracker/models/models.dart';
import 'package:covid_tracker/utils/utils.dart';

class Repository {
  APIClient apiClient;
  Firestore fireStore;

  Repository(this.apiClient, this.fireStore);

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
            data: List<DailyStats>.from(result.data['result'].entries
                .map((element) => DailyStats.fromJson(element))));
      }
      return ResponseResult.fromError(result.statusMessage);
    } catch (error) {
      logger.v('Error - $error');
      return ResponseResult.fromError(error);
    }
  }

  //! Firestore Collection Query
  Future<ResponseResult<List<Tip>>> getHomeTips() async {
    try {
      QuerySnapshot _query = await fireStore.collection('tips').getDocuments();
      var _docs =
          List<Tip>.from(_query.documents.map((doc) => Tip.fromJson(doc.data)));
      if (_docs != null) {
        return ResponseResult(
          state: ResponseState.SUCCESS,
          data: _docs,
        );
      }
      return null;
    } catch (error) {
      logger.v('Error - getMainHomeApp - $error');
      return ResponseResult.fromError(error);
    }
  }
}
