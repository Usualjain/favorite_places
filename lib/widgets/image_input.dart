import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget{
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput>{
  File? _selectedImage;

  void _takepicture ()async{
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600, );
    if(pickedImage == null){
      return;
    }
    setState(() {
       _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
   
  }
  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
          onPressed: _takepicture, 
          icon: const Icon(Icons.camera_alt_rounded), 
          label: const Text('Take Picture')
        );

    if(_selectedImage != null){
      content = Image.file(
        _selectedImage!, 
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,);
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
      child: content,
    );
  }
}