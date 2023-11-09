import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

class Circuit {
  Color couleur;
  List<LatLng> points;

  Circuit({required this.couleur, required this.points});

  static toutLesCircuits() async {
    List<Circuit> circuits = [];
    Uri url = Uri.parse(
        "https://data.nantesmetropole.fr/api/explore/v2.1/catalog/datasets/244400404_tan-circuits/records?limit=100");
    Response reponse = await get(url);
    var json = jsonDecode(reponse.body);
    int totalCount = json["total_count"];
    for (int i = 0; i <= totalCount; i += 100) {
      url = Uri.parse(
          "https://data.nantesmetropole.fr/api/explore/v2.1/catalog/datasets/244400404_tan-circuits/records?offset=$i&limit=100");
      reponse = await get(url);
      json = jsonDecode(reponse.body);
      circuits.addAll(List<Circuit>.from(json["results"].map((e) {
        var p = List<LatLng>.from(e["shape"]["geometry"]["coordinates"][0]
            .map((e) => LatLng(e[1], e[0])));
        var c = Color(int.parse(e["route_color"], radix: 16));
        return Circuit(couleur: c, points: p);
      })));
    }
    return circuits;
  }
}

class Arret {
  String nom;
  LatLng point;
  Color couleur;

  Arret({required this.nom, required this.point, required this.couleur});

  static toutLesArrets() async {
    List<Arret> arrets = [];
    Uri url = Uri.parse(
        "https://data.nantesmetropole.fr/api/explore/v2.1/catalog/datasets/244400404_tan-arrets/records?limit=100");
    Response reponse = await get(url);
    var json = jsonDecode(reponse.body);
    int totalCount = json["total_count"];
    for (int i = 0; i <= totalCount; i += 100) {
      url = Uri.parse(
          "https://data.nantesmetropole.fr/api/explore/v2.1/catalog/datasets/244400404_tan-arrets/records?offset=$i&limit=100");
      reponse = await get(url);
      json = jsonDecode(reponse.body);
      arrets.addAll(List<Arret>.from(json["results"].map((e) {
        var p =
            LatLng(e["stop_coordinates"]["lat"], e["stop_coordinates"]["lon"]);
        var c = const Color.fromARGB(255, 0, 0, 255);
        var nom = e["stop_name"];
        return Arret(couleur: c, point: p, nom: nom);
      })));
    }
    return arrets;
  }
}

class Cluster {
  List<Arret> arrets;

  Cluster({required this.arrets});

  static toutLesClusters() async {
    List<Cluster> clusters = [];
    Uri url = Uri.parse(
        "https://data.nantesmetropole.fr/api/explore/v2.1/catalog/datasets/244400404_tan-arrets/records?limit=100");
    Response reponse = await get(url);
    var json = jsonDecode(reponse.body);
    int totalCount = json["total_count"];

    for (int i = 0; i <= totalCount; i += 100) {
      url = Uri.parse(
          "https://data.nantesmetropole.fr/api/explore/v2.1/catalog/datasets/244400404_tan-arrets/records?offset=$i&limit=100");
      reponse = await get(url);
      json = jsonDecode(reponse.body);
      List<Arret> arrets = List<Arret>.from(json["results"].map((e) {
        var p =
            LatLng(e["stop_coordinates"]["lat"], e["stop_coordinates"]["lon"]);
        var c = const Color.fromARGB(255, 0, 0, 255);
        var nom = e["stop_name"];
        return Arret(couleur: c, point: p, nom: nom);
      }));
      clusters.add(Cluster(arrets: arrets));
    }
    return clusters;
  }
}
