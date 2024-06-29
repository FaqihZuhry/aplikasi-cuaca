// lib/cubits/weather_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future<void> getWeather(String place) async {
    emit(WeatherLoading());
    try {
      final response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$place&appid=64997e381ec4dc6a7821ca68178424d1&units=metric"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(WeatherLoaded(data));
      } else {
        emit(WeatherError("Failed to load weather data"));
      }
    } catch (e) {
      emit(WeatherError("Failed to connect to the server"));
    }
  }
}
