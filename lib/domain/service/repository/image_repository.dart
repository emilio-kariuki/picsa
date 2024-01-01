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
        quality: 50,
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
      final compressedImage = await compressImage(image: image);
      await supabase.auth
          .setSession(supabase.auth.currentSession!.refreshToken!);
      await supabase.storage.from('picsa').upload(
            imageKey,
            compressedImage,
            retryAttempts: 3,
          );
      await supabase.from('Images').upsert(
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': imageKey,
          'url': supabase.storage.from('picsa').getPublicUrl(imageKey),
          'userId': supabase.auth.currentUser!.id,
          'eventId': eventId,
        },
      );
      debugPrint("The image has been inserted");
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

    Future<int> imagesTaken({required String eventId}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final images = await supabase
          .from('Images')
          .select()
          .eq('eventId', eventId)
          .eq('userId', userId);
      return images.length;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
}
