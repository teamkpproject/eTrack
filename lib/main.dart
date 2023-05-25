import 'package:etrack/shared/constants.dart';
import 'package:etrack/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Authentication/auth_data.dart';
import 'models/user.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();





  if(kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: firebaseConfig.apiKey,
          appId: firebaseConfig.appId,
          messagingSenderId: firebaseConfig.messagingSenderId,
          projectId: firebaseConfig.projectId)
    );
  }
  else{
    await Firebase.initializeApp();
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserObj?>.value(
      initialData: null,
      value:AuthService().user,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:Wrapper()
      ),
    );
  }
}

