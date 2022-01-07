import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Makanan{
  final String ? nama;
  final String ? imageUrl;
  final List ? bahan;
  final double ? saran;
  final String ? uid;
  final String ? jenisMakanan;
  final String ? caraMasak;

  Makanan({this.nama, this.imageUrl, this.bahan, this.saran = 1, this.uid, this.jenisMakanan, this.caraMasak});

  // static final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;

  static toMap(Makanan makanan){
    return {
      'nama': makanan.nama,
      'imageUrl': makanan.imageUrl,
      'bahan': makanan.bahan,
      'jenisMakanan': makanan.jenisMakanan,
      'caraMasak': makanan.caraMasak
    };
  }

  static Makanan fromQueryDocumentSnapshot(QueryDocumentSnapshot q) {
    var data = q.data()! as Map<String, dynamic>;
    // print('Data : ${data.toString()}');
    return Makanan(
      nama: data['nama'],
      imageUrl: data['imageUrl'],
      bahan: data['bahan'],
      jenisMakanan: data['jenisMakanan'],
      caraMasak: data['caraMasak'],
      uid: q.id
    );
  }
}