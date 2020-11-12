import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary =
      CloudinaryPublic('mobileproject', 't972zvyw', cache: false);

  Future<String> uploadImage(File image) async {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(image.path,
          resourceType: CloudinaryResourceType.Image),
    );
    return response.secureUrl;
  }
}
