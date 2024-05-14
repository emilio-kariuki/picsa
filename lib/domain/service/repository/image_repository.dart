import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:picsa/utilities/packages.dart';

abstract class ImageTemplate {
  Future<File> compressImage({required File image});
  Future<bool> uploadImage(
      {required String path, required String eventId, required bool isHd});
  Future<bool> deleteImage({required String path});
  Future<int> imagesTaken({required String eventId});
}

class ImageRepository extends ImageTemplate {
  @override
  Future<File> compressImage({required File image}) async {
    try {
      final filePath = image.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp('.jp|png'));
      final split = filePath.substring(0, lastIndex);
      final outPath = '${split}_out${filePath.substring(lastIndex)}';
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        outPath,
        quality: 40,
      );
      return File(result!.path);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error compressing image');
    }
  }

  @override
  Future<bool> uploadImage(
      {required String path,
      required String eventId,
      required bool isHd}) async {
    try {
      File image = File(path);
      final id = supabase.auth.currentUser!.id;
      final imageKey =
          'images/$id/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedImage = isHd ? image : await compressImage(image: image);
      await supabase.storage.from('picsa').upload(
            imageKey,
            compressedImage,
            retryAttempts: 3,
          
          );
      await supabase.from('Images').upsert(
        {
          'id': "$eventId${DateTime.now().millisecondsSinceEpoch.toString()}",
          'name': imageKey,
          'url': supabase.storage.from('picsa').getPublicUrl(imageKey),
          'userId': supabase.auth.currentUser!.id,
          'eventId': eventId,
          'hd': isHd,
        },
      );
      debugPrint("The image has been inserted");
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error uploading image');
    }
  }

  @override
  Future<bool> deleteImage({required String path}) async {
    try {
      await supabase.storage.from('picsa').remove([path]);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error deleting image');
    }
  }

  @override
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
