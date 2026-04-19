import 'package:flutter/material.dart';
import 'package:good_doctor/panic_result_page.dart';

class PanicInputPage extends StatefulWidget {
  @override
  _PanicInputPageState createState() => _PanicInputPageState();
}

class _PanicInputPageState extends State<PanicInputPage> {
  double hr = 116.0,
      sr = 79.0,
      temp = 33.0,
      lux = 10000.0,
      snd = 32.0,
      hum = 50.0;

  Widget _buildSliderCard(String label, String value, double val, double min,
      double max, IconData icon, Color color, Function(double) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Text(label,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
              ]),
              Text(value,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Slider(
            value: val, min: min, max: max,
            activeColor: const Color(0xFF311B92), // Match HomeScreen purple
            inactiveColor: Colors.white10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A3E), Color(0xFF311B92), Color(0xFF4A148C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Sensor Data Input",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSliderCard(
                        "Heart Rate",
                        "${hr.toStringAsFixed(1)} BPM",
                        hr,
                        40,
                        200,
                        Icons.favorite,
                        Colors.purpleAccent,
                        (v) => setState(() => hr = v)),
                    _buildSliderCard(
                        "Skin Resistance",
                        "${sr.toStringAsFixed(1)} kΩ",
                        sr,
                        10,
                        100,
                        Icons.bolt,
                        Colors.blueAccent,
                        (v) => setState(() => sr = v)),
                    _buildSliderCard(
                        "Temperature",
                        "${temp.toStringAsFixed(1)} °C",
                        temp,
                        20,
                        45,
                        Icons.thermostat,
                        Colors.orangeAccent,
                        (v) => setState(() => temp = v)),
                    _buildSliderCard(
                        "Light Intensity",
                        "${lux.toInt()} Lux",
                        lux,
                        0,
                        20000,
                        Icons.wb_sunny,
                        Colors.yellowAccent,
                        (v) => setState(() => lux = v)),
                    _buildSliderCard(
                        "Sound Level",
                        "${snd.toStringAsFixed(1)} dB",
                        snd,
                        0,
                        120,
                        Icons.volume_up,
                        Colors.cyanAccent,
                        (v) => setState(() => snd = v)),
                    _buildSliderCard(
                        "Humidity",
                        "${hum.toInt()} %",
                        hum,
                        0,
                        100,
                        Icons.water_drop,
                        Colors.indigoAccent,
                        (v) => setState(() => hum = v)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => PanicResultPage(
                              heartRate: hr,
                              skinResistance: sr,
                              temperature: temp,
                              lux: lux,
                              sound: snd,
                              humidity: hum))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("ANALYZE STATE",
                      style: TextStyle(
                          color: Color(0xFF0A0A3E),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
