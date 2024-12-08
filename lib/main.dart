import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_proj_eco/profile/profile_screen.dart';

import 'cart/cartScreen.dart';
import 'features/home/home.dart';
import 'features/sign_up/signUp.dart';
import 'features/splash/splash_view.dart';
import 'features/wishList/wishList.dart';
import 'firebase_options.dart';
import 'login/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/wishlist': (context) => WishlistPage(currentIndex: 1,),
        '/cart': (context) => CartScreen(currentIndex: 2,),
        '/profile': (context) => ProfileScreen(currentIndex: 3,),
      },
    );
  }
}