import 'dart:io';

import 'package:picsa/domain/service/repository/image_repository.dart';

class ImageProviders extends ImageTemplate {
  final ImageRepository _imageRepository;
  ImageProviders({required ImageRepository imageRepository})
      : _imageRepository = imageRepository;

  @override
  Future<File> compressImage({required File image}) {
    return _imageRepository.compressImage(image: image);
  }

  @override
  Future<bool> deleteImage({required String path}) {
    return _imageRepository.deleteImage(path: path);
  }

  @override
  Future<int> imagesTaken({required String eventId}) {
    return _imageRepository.imagesTaken(eventId: eventId);
  }

  @override
  Future<bool> uploadImage({required String path, required String eventId, required bool isHd}) {
    return _imageRepository.uploadImage(path: path, eventId: eventId, isHd: isHd);
  }
}
