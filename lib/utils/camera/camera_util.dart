import 'package:multi_image_picker/multi_image_picker.dart';

enum ImageOptions {camera, gallery}

class CameraUtils {
  static CameraUtils _instance;

  CameraUtils._createInstance();

  factory CameraUtils() {
    if (_instance == null) {
      _instance = CameraUtils._createInstance(); // Execute only once to make singleton object
    }
    return _instance;
  }

  Future<List<Asset>> getPhotoFromGallery({List<Asset> initialAssets}) async{
    try {
      //TODO: Customizing
      List<Asset> assets =  await MultiImagePicker.pickImages(
          maxImages: 3,
          enableCamera: true,
        selectedAssets: initialAssets ?? const [],
      );
      return assets;
    } catch (e) {
      print('take photo from gallery error  : $e');
      return null;
    }
  }
}