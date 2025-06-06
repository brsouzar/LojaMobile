import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const ImageSourceSheet({required this.onImageSelected});

  void ImageSelected(XFile image) async {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
         sourcePath: image.path,
         aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
       );
       onImageSelected(File(croppedImage!.path));
   }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () async {
                 XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
                 ImageSelected(image!);
                },
                child: Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                ImageSelected(image!);
              },
              child: Text('Galeria'),
            ),
          ],
        ),
    );
  }
}
