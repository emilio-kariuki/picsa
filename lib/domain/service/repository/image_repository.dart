import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:picsa/utilities/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<bool> uploadImage({
    required String path,
    required String eventId,
  }) async {
    try {
      File image = File(path);
      final imageKey = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      debugPrint('the image key: $imageKey');
      // final compressedImage = await compressImage(image: image);
      // final result = await compressedImage.exists();
      await supabase.auth
          .setSession(supabase.auth.currentSession!.refreshToken!);
      await supabase.storage
          .from('picsa')
          .upload(imageKey, image,
              retryAttempts: 3,
              );
      final url =
          supabase.storage.from('picsa').getPublicUrl(imageKey);
      await supabase.from('Images').upsert({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': imageKey,
        'url': url,
        'userId': supabase.auth.currentUser!.id,
        'eventId': eventId,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error uploading image');
    }
  }

  Future<bool> deleteImage({required String path}) async {
    try {
      await supabase.storage.from('picsa').remove([path]);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting image');
    }
  }
}
