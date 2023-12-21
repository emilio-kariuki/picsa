import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:picsa/utilities/supabase_config.dart';

class ImageRepository {
  Future<File> compressImage({required File image}) async {
    try {
      final filePath = image.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp('.jp|png'));
      final split = filePath.substring(0, lastIndex);
      final outPath = '${split}_out${filePath.substring(lastIndex)}';
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        outPath,
        quality: 5,
      );
      return File(result!.path);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error compressing image');
    }
  }

  Future<bool> uploadImage({required String path}) async {
    try {
      File image = File(path);
      final compressedImage = await compressImage(image: image);
      final result = await compressedImage.exists();
      await supabase.storage.from('picsa').upload(
            'images/${DateTime.now().millisecondsSinceEpoch}.jpg',
            result ? compressedImage : image,
          );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error uploading image');
    }
  }

  

  
}
