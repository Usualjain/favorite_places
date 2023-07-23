import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget{

  const MapScreen({super.key, this.location = const PlaceLocation(latitute: 21.8380, longitude: 73.7191, address: ''), this.isSelecting = true});

  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  LatLng? _pickedLocation;

  void onSaveMap(){
    if(_pickedLocation == null){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.transparent,
            
          padding: EdgeInsets.all(12),
          content: 
             Text('No Location Selected', 
              textAlign: TextAlign.center, 
            ),
          ),
        );
    }else{
      Navigator.of(context).pop(_pickedLocation);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if(widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: onSaveMap,
            ),
        ],
      ),
      body: GoogleMap(
        onTap: 
        !widget.isSelecting  ? null:
        (position){
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(target: LatLng(widget.location.latitute, widget.location.longitude),
        zoom: 16,
        ),
        markers: (_pickedLocation == null && widget.isSelecting)?{} : 
        {
          Marker(markerId: const MarkerId('m1'), 
          position: _pickedLocation != null ? 
          _pickedLocation! : 
          LatLng(widget.location.latitute, widget.location.longitude))
        },
      ),
    );
  }
}