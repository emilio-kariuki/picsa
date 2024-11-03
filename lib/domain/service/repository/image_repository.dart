import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as uploader;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:picsa/main.dart';
import 'package:picsa/utilities/dio_interceptor.dart';
import 'package:picsa/utilities/packages.dart';

abstract class ImageTemplate {
  Future<File> compressImage({required File image});
  Future<bool> uploadImage(
      {required String path, required String eventId, required bool isHd});
  Future<bool> deleteImage({required String path});
  Future<int> imagesTaken({required String eventId});
}

class ImageRepository extends ImageTemplate {
  late final Dio _dio;

  ImageRepository() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }

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
      final compressedImage = isHd ? image : await compressImage(image: image);
      var formData = uploader.FormData.fromMap({
        "image": await uploader.MultipartFile.fromFile(compressedImage.path,
            filename: compressedImage.path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      }, uploader.ListFormat.multi);
      final response = await _dio.post('$API_URL/images/upload?hd=$isHd',
          options: Options(
            contentType: 'multipart/form-data',
          ),
          data: formData);
      if(response.statusCode != 200) {
        throw Exception('Error uploading image');
      }
      logger.d('Image uploaded - ${response.data}');
      final createImageResponse =  await _dio.post('$API_URL/images/create',
          options: Options(
            contentType: 'application/json',
          ),
          data: jsonEncode({
            'name': response.data['name'],
            'url': response.data['url'],
            'eventId': eventId,
            'hd': isHd
          })
          ); 
      if(createImageResponse.statusCode != 200) {
        throw Exception('Error uploading image');
      }
      logger.d('Image created - ${createImageResponse}');
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
