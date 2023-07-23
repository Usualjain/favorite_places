import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/provider/places_provider.dart';


class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace(){

    String text = _titleController.text;
    if(text.isEmpty || _selectedImage == null || _selectedLocation == null){
      return;
    }
    ref.read(placesProvider.notifier).addPlace(text, _selectedImage!, _selectedLocation!);
              Navigator.of(context).pop();
  }

  @override
  void dispose(){
    _titleController.dispose();
    super.dispose();
  }

  @override  
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place')
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text('Name')),
              maxLength: 30,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              validator: (value){
                if(value == null || value.isEmpty || value.trim().length > 30 || value.trim().length <= 1){
                  return 'Must  be between 1 and 30 characters';
                }
              },
              controller: _titleController,
            ),
            const SizedBox(height: 10,),
            ImageInput(onPickImage: (image){
              _selectedImage = image;
            },),
            const SizedBox(height: 16,),
            const SizedBox(height: 10,),
            LocationInput(onSelectLocation: (loc) {_selectedLocation = loc;}),
            const SizedBox(height: 16,),
            ElevatedButton.icon(
              onPressed: _savePlace, 
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ) 
      
    );
  }
}