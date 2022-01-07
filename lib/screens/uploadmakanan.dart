import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runa/services/api/makanan.dart';
import 'package:runa/services/models/makanan.dart';

class MakananUpload extends StatefulWidget {
  const MakananUpload({Key? key}) : super(key: key);

  @override
  _MakananUploadState createState() => _MakananUploadState();
}

class _MakananUploadState extends State<MakananUpload> {
  TextEditingController namaController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String caraMasak = '';
  List<String> bahan = [];
  late String fileName = '';
  File pictureFile = File('');
  String jenisMakanan = '';
  bool onLoading = false;

  loading(){
    setState(() {
      onLoading = !onLoading;
    });
  }

  Future<File?> getPicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      _showAlert('Pilih file dibatalkan', Colors.blueGrey.shade600);
    }
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
                margin: EdgeInsets.only(top: height(1), bottom: height(3)),
                height: height(10),
                width: width(80),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: "Nama Makanan",
                    hintText: "contoh : Pecel Lele",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                ),
              ),
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
              Container(
                margin: EdgeInsets.only(top: height(1)),
                height: height(3),
                child: Text('Gambar : '),
              ),
              Container(
                  margin: EdgeInsets.only(top: height(1), bottom: height(4)),
                  width: width(80),
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: Colors.blue,
                    dashPattern: [1, 3],
                    radius: Radius.circular(12),
                    padding: EdgeInsets.symmetric(vertical: height(1), horizontal: width(1)),
                    child: Column(
                      children: [
                        SizedBox(height: fileName == '' ? 0 : height(2),),
                        fileName == '' ? SizedBox(height: 0) : Container(
                          margin: EdgeInsets.only(bottom: height(1)),
                          height: height(30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Image.file(pictureFile, fit: BoxFit.fitHeight,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width(50),
                                child: Text(fileName == '' ? 'Ketuk untuk menambahkan' : fileName, overflow: TextOverflow.ellipsis,)
                            ),
                            MaterialButton(
                              minWidth: width(20),
                              onPressed: () async {
                                File? file = await getPicture();
                                setState(() {
                                  fileName = (file!.path.split('/') as List<String>).last;
                                  pictureFile = file;
                                });
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Text(fileName == '' ? 'upload' : 'ubah'),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
              ),
              MaterialButton(
                minWidth: width(80),
                height: height(8),
                onPressed: () async {
                  if(jenisMakanan != '' && fileName != '' && caraMasak != '' && namaController.text.isNotEmpty && bahan.isNotEmpty){
                    loading();
                    Makanan makanan = new Makanan(nama: namaController.text.toString(), bahan: bahan, imageUrl: 'makanan/${getRandomString(10)}.${(fileName.split('.') as List<String>).last}', jenisMakanan: jenisMakanan);
                    await MakananApi.makananUpload(makanan, pictureFile.path).then((value) => value == 200 ? {Navigator.pop(context), _showAlert('Upload Sukses', Colors.teal)}
                            : _showAlert('Terjadi Kesalahan, mohon cek koneksi anda', Colors.amber));
                  loading();
                  }
                },
                color: (jenisMakanan != '' && fileName != '' && caraMasak != '' && namaController.text.isNotEmpty && bahan.isNotEmpty) ? Colors.blue : Colors.blueGrey.shade600,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: !onLoading ? Text('submit') : Text('Uploading ... '),
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

class SelectCaraMasak extends StatefulWidget {
  final Function(String value) ? onChanged;
  SelectCaraMasak({Key? key, this.onChanged}) : super(key: key);

  @override
  _SelectCaraMasakState createState() => _SelectCaraMasakState();
}

class _SelectCaraMasakState extends State<SelectCaraMasak> {
  int selectedItem = -1;

  List listCaraMasak = [
    "Direbus",
    "Digoreng",
    "Dikukus",
    "Dipanggang",
    "Ditumis"
  ];

  changeItem(int index){
    setState(() {
      selectedItem = index;
    });
    widget.onChanged!(listCaraMasak[index]);
  }

  @override
  Widget build(BuildContext context) {
    double height(double heightPrecentage){
      return heightPrecentage / 100 * MediaQuery.of(context).size.height;
    }
    double width(double widthPrecentage){
      return widthPrecentage / 100 * MediaQuery.of(context).size.width;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height(25), horizontal: width(2.5)),
      child: Container(
        width: width(90),
        height: height(50),
        padding: EdgeInsets.symmetric(
            vertical: height(0.5),),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(11)),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Pilih Cara Masak',
                  style: TextStyle(color: Colors.blueGrey.shade600)),
              SizedBox(
                height: height(30),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()
                  ),
                  itemCount: listCaraMasak.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => changeItem(index),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                              color: selectedItem == index ? Colors.blue : Colors.white),
                          child: Text(
                            listCaraMasak[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: selectedItem == index ? Colors.white : Colors.blue),
                          )
                        ),
                      );
                    }
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                  child: Text('Simpan dan tutup',
                  style: TextStyle(color: Colors.blueGrey.shade600))
              )
            ],
          )
        ),
      ),
    );
  }
}

class JenisMakananChoose extends StatefulWidget {
  final Function(String value) ? onChanged;
  JenisMakananChoose({Key? key, this.onChanged}) : super(key: key);

  @override
  _JenisMakananChooseState createState() => _JenisMakananChooseState();
}

class _JenisMakananChooseState extends State<JenisMakananChoose> {
  int selectedItem = -1;

  List jenisMakanan = [
    "Ringan",
    "Berat",
  ];

  changeItem(int index){
    setState(() {
      selectedItem = index;
    });
    widget.onChanged!(jenisMakanan[index]);
  }

  @override
  Widget build(BuildContext context) {
    double height(double heightPrecentage){
      return heightPrecentage / 100 * MediaQuery.of(context).size.height;
    }
    double width(double widthPrecentage){
      return widthPrecentage / 100 * MediaQuery.of(context).size.width;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height(25), horizontal: width(2.5)),
      child: Container(
        width: width(90),
        height: height(50),
        padding: EdgeInsets.symmetric(
          vertical: height(0.5),),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(11)),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Pilih Jenis Makanan',
                    style: TextStyle(color: Colors.blueGrey.shade600)),
                SizedBox(
                  height: height(30),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()
                      ),
                      itemCount: jenisMakanan.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => changeItem(index),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  color: selectedItem == index ? Colors.blue : Colors.white),
                              child: Text(
                                jenisMakanan[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: selectedItem == index ? Colors.white : Colors.blue),
                              )
                          ),
                        );
                      }
                  ),
                ),
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text('Simpan dan tutup',
                        style: TextStyle(color: Colors.blueGrey.shade600))
                )
              ],
            )
        ),
      ),
    );
  }
}


class AddBahan extends StatefulWidget {
  final Function(List<String> listBahan) ? onChanged;
  final List<String> bahan;
  AddBahan({Key? key, this.onChanged, required this.bahan}) : super(key: key);

  @override
  _AddBahanState createState() => _AddBahanState();
}

class _AddBahanState extends State<AddBahan> {
  TextEditingController bahanMakananController = TextEditingController();
  List<String> listBahan = [];

  addBahan(String value){
    setState(() {
      listBahan.add(value);
      bahanMakananController.clear();
    });
    widget.onChanged!(listBahan);
  }

  removeBahan(int index){
    setState(() {
      listBahan.removeAt(index);
    });
    widget.onChanged!(listBahan);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listBahan = widget.bahan;
  }

  @override
  Widget build(BuildContext context) {
    double height(double heightPrecentage){
      return heightPrecentage / 100 * MediaQuery.of(context).size.height;
    }
    double width(double widthPrecentage){
      return widthPrecentage / 100 * MediaQuery.of(context).size.width;
    }
    return Padding(
      padding: EdgeInsets.only(top: height(15), bottom: listBahan.isEmpty ? height(30) : height(20), left: width(2.5), right: width(2.5)),
      child: Container(
        width: width(90),
        height: listBahan.isEmpty ? height(30) : height(60),
        padding: EdgeInsets.symmetric(
          vertical: height(0.5),),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(11)),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Tambahkan Bahan Makanan',
                      style: TextStyle(color: Colors.blueGrey.shade600)),
                  Container(
                    height: height(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: width(60),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: bahanMakananController,
                            decoration: InputDecoration(
                              labelText: "Bahan Makanan",
                              hintText: "contoh : Tepung",
                            ),
                            autocorrect: true,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        IconButton(onPressed: () {
                          if(bahanMakananController.text.isNotEmpty && bahanMakananController.text.isNotEmpty){
                            addBahan(bahanMakananController.text.toString());
                          }
                        }, icon: Icon(Icons.add, color: Colors.blue,))
                      ],
                    ),
                  ),
                  listBahan.isEmpty ? SizedBox(height: 20,) : SizedBox(
                    height: height(30),
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()
                        ),
                        itemCount: listBahan.length,
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
                                    listBahan[index],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue),
                                  ),
                                  IconButton(onPressed: () {
                                    removeBahan(index);
                                  }, icon: Icon(Icons.remove, color: Colors.red))
                                ],
                              )
                          );
                        }
                    ),
                  ),
                  SizedBox(
                    height: height(8),
                    child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text('Simpan dan tutup',
                            style: TextStyle(color: Colors.blueGrey.shade600))
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}


