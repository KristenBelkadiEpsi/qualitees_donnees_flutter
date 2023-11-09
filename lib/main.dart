import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Circuit> circuits = [];
  List<Arret> arrets = [];
  LatLng centre = const LatLng(47.206221724344566, -1.5393669020595195);

  double interpolation(double x, double a, double b) {
    return x * (b - a) + a;
  }

  Color interpolationRougeBleu(double x) {
    Color a = const Color.fromARGB(255, 255, 0, 0);
    Color b = const Color.fromARGB(255, 0, 0, 255);
    return Color.fromARGB(
        255,
        interpolation(x, a.red.toDouble(), b.red.toDouble()).toInt(),
        interpolation(x, a.green.toDouble(), b.green.toDouble()).toInt(),
        interpolation(x, a.blue.toDouble(), b.blue.toDouble()).toInt());
  }

  Future<void> initStateAsync() async {
    circuits = await Circuit.toutLesCircuits();
    arrets = await Arret.toutLesArrets();
    setState(() {});
    print("fini de chargé !");
  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(options: MapOptions(initialCenter: centre), children: [
      TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: "com.example.com",
      ),
      PolylineLayer(
          polylines: List.generate(circuits.length, (index) {
        Color c = circuits[index].couleur;

        return Polyline(
            points: circuits[index].points,
            color: Color.fromARGB(c.red, c.green, c.blue, c.alpha),
            borderColor: Color.fromARGB(c.red, c.green, c.blue, c.alpha),
            strokeWidth: 5.0);
      })),
      MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 160,
          size: const Size(80, 80),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(50),
          maxZoom: 13,
          markers: List.generate(
            arrets.length,
            (index) => Marker(
                point: arrets[index].point,
                child: Tooltip(
                    message: arrets[index].nom,
                    child: const Icon(Icons.info, color: Colors.blue))),
          ),
          builder: (context, markers) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45), color: Colors.blue),
              child: Center(
                child: Text(
                  markers.length.toString(),
                  style: TextStyle(
                      color: interpolationRougeBleu(
                          (markers.length.toDouble()) / 100.0)),
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}
