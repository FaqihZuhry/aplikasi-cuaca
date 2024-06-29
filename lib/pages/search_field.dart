// lib/pages/search_field.dart

import 'package:flutter/material.dart';
import 'result.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController placeController = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Weather App", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
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
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Masukkan nama Kota atau provinsi",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    controller: placeController,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Result(place: placeController.text);
                        }),
                      );
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}