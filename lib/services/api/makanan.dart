import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:runa/services/models/makanan.dart';

class MakananApi{

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;

  static Future<List<Makanan>> getData() async {
    QuerySnapshot snapshot = await _firestore.collection('makanan').get();
    List<Makanan> makanan = snapshot.docs.map((e) {
      return Makanan.fromQueryDocumentSnapshot(e);
    }).toList();
    print(makanan.first.uid);
    return makanan;
  }

  static Future<List<Map<String, dynamic>>> getRecommendedFoodRanking(bool makananRingan, List<String> bahanMakanan, String caraMasak) async {
     List<Map<String, dynamic>> rFood = await getData().then((makanan) async {
      print('data makanan is ${makanan.length}');
      String jenisMakanan = makananRingan ? 'ringan' : 'berat';
      // List<int> bahanMasak = [];

      Future<List<Map<String, dynamic>>> getJenisMakananPoin() async {
        // List<Map<String, dynamic>> poin = [];
        return makanan.map((e) {
          print(e.jenisMakanan!.toLowerCase());
          if(e.jenisMakanan!.toLowerCase() == jenisMakanan ){
            return {'uid': e.uid, 'poin': 5};
          }else{
            return {'uid': e.uid, 'poin': 3};
          }
        }).toList();

        // return poin;
      }

      Future<List<Map<String, dynamic>>> getCaraMasakPoin() async {
        // List<Map<String, dynamic>> poin = [];
        return makanan.map((e) {
          int poinn = 1;
          switch(e.caraMasak!.toLowerCase()){
            case 'direbus':
              poinn = 5;
              break;
            case 'digoreng':
              poinn = 4;
              break;
            case 'dikukus':
              poinn = 3;
              break;
            case 'dipanggang':
              poinn = 2;
              break;
            case 'ditumis':
              poinn = 1;
              break;
          }
          return {'uid': e.uid, 'poin': poinn};
        }).toList();

        // return poin;
      }

      Future<List<Map<String, dynamic>>> getBahanMakananPoin() async {
        return makanan.map((e) {
          int pPlus = 0;
          List.generate(e.bahan!.length, (index) => (bahanMakanan.where((element) => element == e.bahan![index]).toList()).isNotEmpty ? pPlus += 1 : pPlus += 0);
          pPlus = (e.bahan!.length * pPlus/100).round();
          pPlus = pPlus >= 50 ? 5 : 3;
          return {'uid': e.uid, 'poin': pPlus};
        }).toList();

        // return poin;
      }

      int jenisMakananMax = 1;
      // List<int> jMakanan = [];
      List<Map<String, dynamic>> m = await getJenisMakananPoin();
      print(m.first.toString());
      // List.generate(makanan.length, (index) {
      //   jMakanan.add(m[index]['poin']);
      // });
      List<int> jMakanan = m.map((e) => e['poin'] as int).toList();
      print(jMakanan.toString());
      jenisMakananMax = jMakanan.reduce(max);
      int caraMasakMax = 5;
      int bahanMakananMax = 5;

      List<Map<String, dynamic>> bMakananPoin = await getBahanMakananPoin();
      List<Map<String, dynamic>> cMasakPoin = await getCaraMasakPoin();
      List<Map<String, dynamic>> nmJMakanan = [];
      List<Map<String, dynamic>> nmbMakanan = [];
      List<Map<String, dynamic>> nmcMasak = [];
      List<Map<String, dynamic>> rMakanan = [];

      // Normalisasi
      List.generate(makanan.length, (index) {
        nmJMakanan.add({'uid': m[index]['uid'], 'npoin' : (m[index]['poin'] as int)/jenisMakananMax});
        nmbMakanan.add({'uid': bMakananPoin[index]['uid'], 'npoin': (bMakananPoin[index]['poin'] as int)/bahanMakananMax});
        nmcMasak.add({'uid': cMasakPoin[index]['uid'], 'npoin': (cMasakPoin[index]['poin'] as int)/caraMasakMax});
      });

      //sum
      List.generate(makanan.length, (index) {
        double rpoin = ((0.4 * (nmJMakanan[index]['npoin'])) + (0.2 * nmbMakanan[index]['npoin']) + (0.4 * nmcMasak[index]['npoin']));
        rMakanan.add({'uid': makanan[index].uid, 'rpoin': rpoin});
      });

      // Ranking
      rMakanan.sort((i, e) => (i['rpoin'] as double).compareTo(e['rpoin']));
      rMakanan = rMakanan.reversed.toList();
      print(rMakanan.toString());

      List<Map<String, dynamic>> filteredResult = await rMakanan.sublist(0, 4);
      // List<Makanan> result = filteredResult.map((e) {
      //   Makanan mItem = makanan.firstWhere((element) => element.uid == e['uid']);
      //   // String imageDownloadUrl = await _storage.ref(mItem.imageUrl).getDownloadURL();
      //   // print(imageDownloadUrl.toString());
      //   Makanan item = Makanan(nama: mItem.nama, imageUrl: mItem.imageUrl, bahan: mItem.bahan, saran: (rMakanan.length) + 0.0, uid: mItem.uid, jenisMakanan: mItem.jenisMakanan, caraMasak: mItem.caraMasak);
      //   return item;
      // }).toList();
      return filteredResult;


    });

    // List<Makanan> resultM = rFood;
    return rFood;

  }

  static Future<int> makananUpload(Makanan makanan, String filePath) async {
    int turn = 400;
    // String fileExtension = filePath.split('.').last.toString();

    try{
      await _firestore.collection('makanan').add(Makanan.toMap(makanan));
      await uploadFile(filePath, '${((((makanan.imageUrl!.split('/') as List<String>).last) as String).split('.') as List<String>).first }.${(makanan.imageUrl!.split('.') as List<String>).last}');
      turn = 200;
    } on firebase_core.FirebaseException catch (e){
      print(e.toString());
    }


    return turn;
  }

  static Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await _storage.ref('makanan/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    }
  }

}