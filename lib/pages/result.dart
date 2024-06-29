import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;

  const Result({Key? key, required this.place}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<Map<String, dynamic>> _weatherData;
  late Future<Map<String, dynamic>> _hourlyData;

  @override
  void initState() {
    super.initState();
    _weatherData = getDataFromApi();
    _hourlyData = getHourlyDataFromApi();
  }

  Future<Map<String, dynamic>> getDataFromApi() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=64997e381ec4dc6a7821ca68178424d1&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengambil data cuaca");
    }
  }

  Future<Map<String, dynamic>> getHourlyDataFromApi() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=${widget.place}&appid=64997e381ec4dc6a7821ca68178424d1&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengambil data cuaca setiap jam");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.wait([_weatherData, _hourlyData]).then((responses) {
          return {"current": responses[0], "hourly": responses[1]};
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Gagal mengambil data cuaca",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: const Text("Back to Search"),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!["current"];
          final hourlyData = snapshot.data!["hourly"]["list"];

          // Get current date
          DateTime now = DateTime.now();
          String formattedDate = "${now.day}-${now.month}-${now.year}";

          return Stack(
            children: [
              // Background gradient
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 207, 230, 248), // Warna putih di atas kiri
                      Colors.blue, // Warna biru di tengah
                      Colors.blue.shade900, // Warna biru tua di kanan bawah
                    ],
                    stops: const [0.0, 0.5, 1.0], // Pengaturan untuk posisi gradasi
                  ),
                ),
              ),

              // Konten utama yang bisa di-scroll
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "${data["main"]["feels_like"].round()}°C",
                                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8)),
                              ),
                              Text(
                                "${data["weather"][0]["main"]}",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                        Container(
                          width: 350,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.air,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${data["wind"]["speed"].round()}m/s",
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Wind",
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.opacity,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${data["main"]["humidity"].round()}%",
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Humidity",
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${data["visibility"].round()}m",
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Visibility",
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Data per jam
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                              "Today weather",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: 350,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(16.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: hourlyData.length,
                                itemBuilder: (context, index) {
                                  final hourData = hourlyData[index];
                                  final iconUrl = "http://openweathermap.org/img/wn/${hourData["weather"][0]["icon"]}@2x.png";
                                  return Container(
                                    width: 65,
                                    height: 50, // Sesuaikan tinggi kotak di sini
                                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${DateTime.parse(hourData["dt_txt"]).hour}:00",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        Image.network(
                                          iconUrl,
                                          width: 60,
                                          height: 60,
                                        ),
                                        Text(
                                          "${hourData["main"]["temp"].round()}°C",
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // AppBar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Hasil Pencarian
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Text(
                        "${data["name"]}",
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Text(
                        formattedDate,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
