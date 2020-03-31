import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_face_diary/widgets/diary_widgets/icons.dart';

class DiaryModel {
  final int id;
  final String docId;
  final DateTime date;
  final Uint8List image1;
  final Uint8List image2;
  final Uint8List image3;
  final Emotions emotion;
  final Weathers weather;
  final String note;

  DiaryModel({this.id, this.docId, this.date, this.image1, this.image2, this.image3, this.emotion, this.weather, this.note});

  DiaryModel copyWith({int id, DateTime date, Uint8List image1, Uint8List image2, Uint8List image3,
    Emotions emotion, Weathers weather, String note}){
    return DiaryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      emotion: emotion ?? this.emotion,
      weather: weather ?? this.weather,
      note: note ?? this.note,
    );
  }

  List<Uint8List> get images {
    List<Uint8List> list = [];
    if(this.image1 != null){
      list.add(this.image1);
    }
    if(this.image2 != null) {
      list.add(this.image2);
    }
    if(this.image3 != null) {
      list.add(this.image3);
    }
    return list;
  }

  Map<String, dynamic> toMap(){
    return {
      'id': this.id,
      'date': this.date.microsecondsSinceEpoch,
      'image1': this.image1,
      'image2': this.image2,
      'image3': this.image3,
      'emotion': this.emotion.toShortString(),
      'weather': this.weather.toShortString(),
      'note': this.note,
    };
  }

  static DiaryModel fromMap(Map map){
    return DiaryModel(
        id: map['id'],
        date: DateTime.fromMicrosecondsSinceEpoch(map['date']),
        image1: map['image1'],
        image2: map['image2'],
        image3: map['image3'],
        emotion: DiaryIcons.stringToEmotions[map['emotion']],
        weather: DiaryIcons.stringToWeathers[map['weather']],
        note: map['note']
    );
  }

  Map<String, dynamic> toDocument(String imageUrl1, String imageUrl2, String imageUrl3){
    return {
      'date': this.date,
      'image1': imageUrl1,
      'image2': imageUrl2,
      'image3': imageUrl3,
      'emotion': this.emotion.toShortString(),
      'weather': this.weather.toShortString(),
      'note': this.note,
    };
  }

  static fromSnapshot(DocumentSnapshot snap){
    final image1Url = snap.data['image1'] ?? null;
    final image2Url = snap.data['image2'] ?? null;
    final image3Url = snap.data['image3'] ?? null;
    final dateFromSnapshot = snap.data['date']?.toDate();

    return DiaryModel(
        date: dateFromSnapshot.toLocal(),
        docId: snap.documentID,
        image1: image1Url == null ? null : Uint8List.fromList(image1Url.codeUnits),
        image2: image2Url == null ? null : Uint8List.fromList(image2Url.codeUnits),
        image3: image3Url == null ? null : Uint8List.fromList(image3Url.codeUnits),
        emotion: DiaryIcons.stringToEmotions[snap.data['emotion'] ?? ''],
        weather: DiaryIcons.stringToWeathers[snap.data['weather'] ?? ''],
        note: snap.data['note'] ?? ''
    );
  }



  Future uploadImage(List<int> image, String name, String uid) async {
    StorageReference storageReference = FirebaseStorage().ref().child('Diaries').child(uid);
    StorageReference ref = storageReference.child(name);
    StorageUploadTask uploadTask = ref.putData(Uint8List.fromList(image));
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }



  @override
  String toString() {
    return 'DiaryModel{id: $id, date: $date, images: ${images.length} emotion: $emotion, note: $note}';
  }
}