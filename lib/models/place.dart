import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation{
  const PlaceLocation({
    required this.latitute,
    required this.longitude,
    required this.address,
  });
  final double latitute;
  final double longitude;
  final String address;
}
class Place{

  Place({
    required this.title, 
    required this.image, 
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}