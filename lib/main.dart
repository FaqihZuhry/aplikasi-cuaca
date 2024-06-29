// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aplikasi_cuaca/pages/search_field.dart';
import 'package:aplikasi_cuaca/cubits/weather_cubit.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const MaterialApp(
      debugShowCheckedModeBanner: false,
    );
    return BlocProvider(
      create: (context) => WeatherCubit(),
      child: MaterialApp(
        home: SearchField(),
      ),
    );
  }
}
