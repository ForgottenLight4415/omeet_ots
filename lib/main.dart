import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rc_clone/data/repositories/auth_repo.dart';
import 'package:rc_clone/routes/routes.dart';
import 'package:rc_clone/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool _isSignedIn = await AuthRepository().signIn();
  runApp(MyApp(isSignedIn: _isSignedIn));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  const MyApp({Key? key, required this.isSignedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(412, 915),
      builder: (BuildContext context, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OMeet',
        theme: AppTheme.lightTheme,
        builder: (BuildContext? context, Widget? widget) {
          return MediaQuery(
            data: MediaQuery.of(context!).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        onGenerateRoute: RouteGenerator.generateRoute,
        onGenerateInitialRoutes: (_) {
          if (isSignedIn) {
            return [
              RouteGenerator.generateRoute(const RouteSettings(name: '/')),
            ];
          } else {
            return [
              RouteGenerator.generateRoute(const RouteSettings(name: '/login')),
            ];
          }
        },
        scrollBehavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
