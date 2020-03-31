import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_face_diary/screens/image_editor_screen.dart';
import 'package:path/path.dart' as p;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_face_diary/utils/camera/camera_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class EditDiaryImage extends StatefulWidget {
  final Function(List<List<int>> images) onImagesChanged;
  final List<List<int>> initialImages;

  EditDiaryImage({this.onImagesChanged, this.initialImages});

  @override
  _EditDiaryImageState createState() => _EditDiaryImageState();
}

class _EditDiaryImageState extends State<EditDiaryImage> {
  CameraUtils _cameraUtils;
  HashMap<String, Uint8List> _imageCache;
  List<Asset> _assets;
  List<Uint8List> _images;
  int _index;

  bool _isCompressing;

  @override
  void initState() {
    _cameraUtils = CameraUtils();
    _imageCache = HashMap();
    _assets = null;

    _images = widget.initialImages != null
        ? widget.initialImages.map((i) => Uint8List.fromList(i)).toList()
        : null;

    _index = 0;
    _isCompressing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _getImageFromGallery(_assets),
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 3 / 4.5,
        child: _images == null && _isCompressing == false
            ? Container(
              color: Colors.grey[300],
              child: SafeArea(
                top: true,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline),
                      const SizedBox(height: 12.0,),
                      Text('오늘의 모습을 선택하세요.',
                        style: TextStyle(fontSize: 16.0),
                      )]),
              ),
            )
            : _isCompressing
            ? Container(
              color: Colors.grey[300],
              child: SafeArea(
                  top: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox.fromSize(
                          size: Size(15.0, 15.0),
                          child: CircularProgressIndicator(strokeWidth: 2.0,)),
                      const SizedBox(height: 12.0,),
                      Text('이미지 처리중..',
                        style: TextStyle(fontSize: 16.0),)],
                  )),)
            : Stack(
              children: <Widget>[
                CarouselSlider.builder(
                  aspectRatio: 3 / 4.5,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  itemCount: _images.length,
                  onPageChanged: (index){
                    setState(() {
                      _index = index;
                    });
                  },
                  itemBuilder: (context, index){
                    return FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        fit: BoxFit.cover,
                        image: MemoryImage(_images[index])
                    );},),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          child: SizedBox(
                              width:32,
                              height: 30,
                              child: SvgPicture.asset('assets/icons/edit-image.svg', color: Colors.white,)),
                            onPressed: () async {
                              //TODO : 이미지 크롭 커스터마이징
                              Uint8List image = _images[_index];

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ImageEditorScreen(image);
                              }));

//                              Directory tempPath = await getTemporaryDirectory();
//                              String path = p.join(tempPath.path, 'temp_image.jpg');
//                              // create temp image for cropping
//                              File tempImage= File(path);
//                              await tempImage.writeAsBytes(image.toList());
//                              File croppedImage = await ImageCropper.cropImage(
//                                  sourcePath: path,
//                                  compressQuality: 100
//                              );
//                              if (croppedImage != null) {
//                                image = croppedImage.readAsBytesSync();
//                                setState(() {
//                                  _images[_index] = image;
//                                  widget.onImagesChanged(_images.map((i)=>i.toList()).toList());
//                                });
//                                croppedImage.deleteSync();
//                              }
//                              // delete temp images
//                              tempImage.deleteSync();
                            }
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _images.map((image) =>
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _images.indexOf(image) == _index ? Colors.white : Colors.grey
                                ),
                                width: 5.0,
                                height: 5.0,
                              )
                          ).toList(),
                        ),
                      ],
                    ),
                  ),

                )
              ],
            ),
      ),
    );
  }


  Future<void> _getImageFromGallery(List<Asset> initialAssets) async{
    List<Asset> _imageAssets = await _cameraUtils.getPhotoFromGallery(initialAssets: initialAssets);
    if(_imageAssets != null){
      setState(() {
        _isCompressing = true;
      });
      List<Future<Uint8List>> futures = [];
      _imageAssets.forEach((asset) => futures.add(_compressImage(asset)));
      var images = await Future.wait(futures);

      if(widget.onImagesChanged != null){
        widget.onImagesChanged(images.map((image) => image.toList()).toList());
      }
      setState(() {
        _images = images.toList();
        _assets = _imageAssets;
        _isCompressing = false;
      });
    }
  }

  Future<Uint8List> _compressImage(Asset asset, {int minHeight, int minWidth, int quality}) async {
    if(_imageCache.containsKey(asset.name)){
      return _imageCache[asset.name];
    }

    ByteData _imageData = await asset.getByteData();
    var result = await FlutterImageCompress.compressWithList(
      _imageData.buffer.asUint8List().toList(),
      minHeight: minHeight ?? 750,
      minWidth: minWidth ?? 750,
      quality: quality ?? 70,
    );
    Uint8List _resultImage = Uint8List.fromList(result);
    _imageCache.putIfAbsent(asset.name, () => _resultImage);
    await precacheImage(MemoryImage(_resultImage), context);
    return _resultImage;
  }

}


