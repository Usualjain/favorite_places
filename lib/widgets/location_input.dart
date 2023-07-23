import 'dart:convert';

import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/place.dart';
class LocationInput extends StatefulWidget{

  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final Function onSelectLocation;

  State<LocationInput> createState(){
    return _LocationInputState();
  }

}

class _LocationInputState extends State<LocationInput>{

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage{
    if(_pickedLocation == null){
      return '';
    }
    final lat = _pickedLocation!.latitute;
    final lon = _pickedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyBiiLjmWZDBxMev7TAkqab_b7QPPFZKUtc';
  }

  void _getCurrentLocation() async{
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;
    if(lat == null || lon == null){
      return;
    }
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=AIzaSyBiiLjmWZDBxMev7TAkqab_b7QPPFZKUtc');
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(latitute: lat, longitude: lon, address: address);
      widget.onSelectLocation(_pickedLocation);
      _isGettingLocation = false;
    });
  }

  void _selectMapLocation() async{

    setState(() {
      _isGettingLocation = true;
    });
    LatLng pla;
    try{
      pla = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const MapScreen()));
    }catch(error){
      setState(() {
        _isGettingLocation = false;
      });
      return;
    } 

    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${pla.latitude},${pla.longitude}&key=AIzaSyBiiLjmWZDBxMev7TAkqab_b7QPPFZKUtc');
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(latitute: pla.latitude, longitude: pla.longitude, address: address);
      widget.onSelectLocation(_pickedLocation);
      _isGettingLocation = false;
    });
  }



  @override
  Widget build(BuildContext context) {

    Widget previewContent = Text("No location chosen", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,),
          );

    if (_pickedLocation != null){
      previewContent = Image.network(locationImage, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
    }
    if (_isGettingLocation){
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(onPressed: _getCurrentLocation, icon: const Icon(Icons.location_on), label: const Text('Get Current Location')),
            TextButton.icon(onPressed: _selectMapLocation, icon: const Icon(Icons.map), label: const Text('Select On Map')),
          ],
        )
      ],
    );
  }
}
