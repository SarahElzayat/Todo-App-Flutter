import 'package:app1/layout/home_layout.dart';
import 'package:app1/shared/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());

}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
           home: HomeLayout(),
    );
  }


}