import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places/models/place.dart';

Future<Database> _getDatabase() async{
  final dbPath= await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath,'places.db'), 
      onCreate: (db, version) {
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lon REAL, address TEXT)');
      },
    version: 1,
    );
  return db;
}

class NewPlaceNotifier extends StateNotifier<List<Place>>{
  
  NewPlaceNotifier() : super(const []);

  Future<void> loadPlaces() async{
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row){
      return Place(title: row['title'] as String,
      image: File(row['image'] as String),
      location: PlaceLocation(
        latitute: row['lat'] as double, 
        longitude: row['lon'] as double , 
        address: row['address'] as String
      ), 
      id: row['id'] as String);
    }).toList(); 

    state =  places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);


    final copiedImage = await image.copy('${appDir.path}/$filename');
    
    final place = Place(title: title, image: copiedImage, location: location);
    
    final db = await _getDatabase();

    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat' : place.location.latitute,
      'lon': place.location.longitude,
      'address': place.location.address,
    });

    state = [...state, place,];

  }
}

final placesProvider = StateNotifierProvider<NewPlaceNotifier, List<Place>>(
  (ref)=>NewPlaceNotifier()
);