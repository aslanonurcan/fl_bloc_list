import 'package:bloc/bloc.dart';
import 'package:fl_bloc_list/view/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: PostBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class PostBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    'Bloc: $bloc'.log();
    super.onTransition(bloc, transition);
  }

  @override
  void onCreate(BlocBase bloc) {
    'Post Bloc Created'.log();
    super.onCreate(bloc);
  }
}

extension Log on Object {
  void log() => devtools.log(toString());
}
