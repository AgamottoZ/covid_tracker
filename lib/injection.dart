// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/utils/api_client.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'package:covid_tracker/environment.dart';
import 'package:covid_tracker/repository/repository.dart';

final getIt = GetIt.instance;

void initInjector() {
  // Firestore _fireStore = Firestore.instance;
  APIClient _apiClient = APIClient();

  getIt.registerSingleton<Environment>(Environment());
  getIt.registerSingleton<APIClient>(_apiClient);
  getIt.registerSingleton<Repository>(Repository(_apiClient));
}
