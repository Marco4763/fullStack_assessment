import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseAdapter {
  late FirebaseApp app;

  static FirebaseOptions get _currentConfiguration {
    return FirebaseOptions(
      apiKey: dotenv.get('APIKEY'),
      appId: dotenv.get('APPID'),
      messagingSenderId: dotenv.get('MESSAGEID'),
      projectId: dotenv.get('PROJECTID'),
    );
  }

  static Future<FirebaseApp> get initialize async {
    return await Firebase.initializeApp(
        options: _currentConfiguration
    );
  }

  static Future<FirebaseAuth> get auth async {
    return FirebaseAuth.instanceFor(app: await initialize);
  }
}
