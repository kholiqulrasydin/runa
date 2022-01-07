import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runa/screens/masakan.dart';
import 'package:runa/screens/uploadmakanan.dart';
import 'package:runa/services/api/makanan.dart';

class Submit extends StatefulWidget {
  const Submit({Key? key}) : super(key: key);

  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  TextEditingController namaController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String caraMasak = '';
  List<String> bahan = [];
  late String fileName = '';
  String jenisMakanan = '';
  bool onLoading = false;

  loading(){
    setState(() {
      onLoading = !onLoading;
    });
  }

  _showAlert(String msg, Color color){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$msg',
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double height(double heightPrecentage){
      return heightPrecentage / 100 * MediaQuery.of(context).size.height;
    }
    double width(double widthPrecentage){
      return widthPrecentage / 100 * MediaQuery.of(context).size.width;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        title: Text('Upload Makanan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
        ),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: height(1)),
                height: height(3),
                child: Text('Cara Memasak : '),
              ),
              GestureDetector(
                onTap: (){
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context, Animation animation,
                          Animation secondaryAnimation) => SelectCaraMasak(onChanged: (value) {
                        setState(() {
                          caraMasak = value;
                        });
                      },)
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(top: height(1), bottom: height(4)),
                    padding: EdgeInsets.symmetric(vertical: height(1), horizontal: width(1)),
                    width: width(80),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            width: 0.5,
                            color: Colors.blue.shade300
                        )
                    ),
                    child: Text(caraMasak == '' ? 'tekan untuk memilih' : caraMasak, textAlign: TextAlign.center,)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height(1)),
                height: height(3),
                child: Text('Jenis Makanan : '),
              ),
              GestureDetector(
                onTap: (){
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context, Animation animation,
                          Animation secondaryAnimation) => JenisMakananChoose(onChanged: (value) {
                        setState(() {
                          jenisMakanan = value;
                        });
                      },)
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(top: height(1), bottom: height(4)),
                    padding: EdgeInsets.symmetric(vertical: height(1), horizontal: width(1)),
                    width: width(80),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            width: 0.5,
                            color: Colors.blue.shade300
                        )
                    ),
                    child: Text(jenisMakanan == '' ? 'tekan untuk memilih' : jenisMakanan, textAlign: TextAlign.center,)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height(1)),
                height: height(3),
                child: Text('Bahan-Bahan : '),
              ),
              GestureDetector(
                onTap: (){
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context, Animation animation,
                          Animation secondaryAnimation) => AddBahan(onChanged: (value){
                        setState(() {
                          bahan = value;
                        });
                      }, bahan: bahan,)
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(top: height(1), bottom: height(4)),
                    padding: EdgeInsets.symmetric(vertical: height(1), horizontal: width(1)),
                    width: width(80),
                    height: bahan.isEmpty ? height(20) : height(30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            width: 0.5,
                            color: Colors.blue.shade300
                        )
                    ),
                    child: bahan.isEmpty ? Text('bahan-bahan kosong\ntekan untuk menambahkan', textAlign: TextAlign.center,) : ListView.builder(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()
                        ),
                        itemCount: bahan.length,
                        itemBuilder: (context, index) {
                          return Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: width(2)),
                              margin: EdgeInsets.only(
                                  right: width(2),
                                  bottom: height(1),
                                  left: width(2)
                              ),
                              width: width(70),
                              height: height(5),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade100,
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                      offset: Offset(6, 4),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bahan[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue),
                                  ),
                                  // IconButton(onPressed: () {
                                  //   removeBahan(index);
                                  // }, icon: Icon(Icons.remove, color: Colors.red))
                                ],
                              )
                          );
                        }
                    )
                ),
              ),
              MaterialButton(
                minWidth: width(80),
                height: height(8),
                onPressed: () async {
                  if(jenisMakanan != '' && caraMasak != '' && bahan.isNotEmpty){
                    loading();
                    await MakananApi.getRecommendedFoodRanking(jenisMakanan == "Ringan" ? true : false, bahan as List<String>, caraMasak)
                        .then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakananList(makananRanked: value,))));
                    loading();
                  }
                },
                color: (jenisMakanan != '' && caraMasak != '' && bahan.isNotEmpty) ? Colors.blue : Colors.blueGrey.shade600,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: !onLoading ? Text('cari') : Text('mendapatkan data ... '),
              )
            ],
          ),
        ),
      ),
    );
  }
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
