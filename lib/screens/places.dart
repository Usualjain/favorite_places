import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/provider/places_provider.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  
  const PlacesScreen({super.key});
  @override
  ConsumerState<PlacesScreen> createState(){
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen>{
  
  late Future<void>_placesFuture;
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }
  
  @override
  Widget build(BuildContext context) {
    final List<Place> placesList = ref.watch(placesProvider);
    
    void addPlace(){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx)=> const AddPlacesScreen())
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(onPressed: addPlace, icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(future: _placesFuture, builder: (context, snapshot)=> snapshot.connectionState == ConnectionState.waiting?const Center(child: CircularProgressIndicator(),):PlacesList(places:placesList),) ),
    );
  }
}