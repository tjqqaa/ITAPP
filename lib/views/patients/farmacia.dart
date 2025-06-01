import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';

class Farmacia {
  final String nombre;
  final String direccion;
  final String codigoPostal;
  final double lat;
  final double lng;

  Farmacia({
    required this.nombre,
    required this.direccion,
    required this.codigoPostal,
    required this.lat,
    required this.lng,
  });

  factory Farmacia.fromJson(Map<String, dynamic> json) {
    return Farmacia(
      nombre: json['nombre'],
      direccion: json['direccion'],
      codigoPostal: json['codigo_postal'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class FarmaciasCercanasScreen extends StatefulWidget {
  @override
  _FarmaciasCercanasScreenState createState() => _FarmaciasCercanasScreenState();
}

class _FarmaciasCercanasScreenState extends State<FarmaciasCercanasScreen> {
  List<Farmacia> todasLasFarmacias = [];
  List<Farmacia> farmaciasCercanas = [];
  Position? _posicionActual;
  final double radioMetros = 1000; // Cambia el radio si lo deseas

  @override
  void initState() {
    super.initState();
    cargarFarmacias();
    obtenerUbicacion();
  }

  Future<void> cargarFarmacias() async {
    final String respuesta = await rootBundle.loadString('assets/farmacias_wroclaw.json');
    final List<dynamic> datos = json.decode(respuesta);
    setState(() {
      todasLasFarmacias = datos.map((e) => Farmacia.fromJson(e)).toList();
    });
  }

  Future<void> obtenerUbicacion() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) return;
    }
    if (permiso == LocationPermission.deniedForever) return;

    Position posicion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _posicionActual = posicion;
    });
    filtrarFarmaciasCercanas(posicion.latitude, posicion.longitude);
  }

  void filtrarFarmaciasCercanas(double lat, double lng) {
    setState(() {
      farmaciasCercanas = todasLasFarmacias.where((f) {
        double distancia = Geolocator.distanceBetween(
          lat, lng, f.lat, f.lng,
        );
        return distancia <= radioMetros;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pharmacy near')),
      body: _posicionActual == null
          ? Center(child: CircularProgressIndicator())
          : farmaciasCercanas.isEmpty
          ? Center(child: Text('There are no pharmacies near.'))
          : ListView.builder(
        itemCount: farmaciasCercanas.length,
        itemBuilder: (context, index) {
          final farmacia = farmaciasCercanas[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.local_pharmacy, color: Colors.green),
              title: Text(farmacia.nombre),
              subtitle: Text('${farmacia.direccion}\n${farmacia.codigoPostal}'),
            ),
          );
        },
      ),
    );
  }
}
