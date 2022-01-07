import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runa/services/api/makanan.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:runa/services/models/makanan.dart';

class MakananList extends StatefulWidget {
  final List<Map<String, dynamic>> makananRanked;
  MakananList({Key? key, required this.makananRanked}) : super(key: key);

  @override
  State<MakananList> createState() => _MakananListState();
}

class _MakananListState extends State<MakananList> {
  List<Makanan> _makanans = [];
  bool loading = false;

  setLoading(){
    setState(() {
      loading = !loading;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMakananList();
  }

  loadingIstrue(){
    setState(() {
      loading = true;
    });
  }

  Future<void> getMakananList() async {
    setLoading();
    firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
    List<Map<String, dynamic>> _rankedList = widget.makananRanked;
    List<Makanan> _makananList = [];
    List<Makanan> makanan = await MakananApi.getData();
    _rankedList.forEach((e) async {
      Makanan mItem = makanan.firstWhere((element) => element.uid == e['uid']);
        String imageDownloadUrl = await _storage.ref(mItem.imageUrl).getDownloadURL();
        print(imageDownloadUrl.toString());
        Makanan item = Makanan(nama: mItem.nama, imageUrl: imageDownloadUrl, bahan: mItem.bahan, saran: (_rankedList.length) + 0.0, uid: mItem.uid, jenisMakanan: mItem.jenisMakanan, caraMasak: mItem.caraMasak);
        setState(() {
          _makanans.add(item);
        });
        _makananList.add(item);
    });
    print('jumlah makanan '+_makananList.length.toString());

    if(_makananList.isNotEmpty){
      setState(() {
        _makanans = _makananList;
      });
      setLoading();
    }
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
      appBar: AppBar(
        title: Text("Makanan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: height(2)),
        padding: EdgeInsets.symmetric(horizontal: width(5)),
        width: width(100),
        height: height(100),
        child: _makanans.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()
            ),
            itemCount: _makanans.length,
            itemBuilder: (context, index){
              return OperationCard(makanan: _makanans[index]);
            }
        ),
      ),
    );
  }
}

class OperationCard extends StatefulWidget {
  final Makanan makanan;

  OperationCard({required this.makanan});

  @override
  _OperationCardState createState() => _OperationCardState();
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(
          right: 2,
          bottom: 10,
          left: 1
      ),
      width: 100,
      height: 90,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(widget.makanan.imageUrl!, width: 50, height: 50,),
              const SizedBox(
                height: 9,
              ),
              Text(
                widget.makanan.nama!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: RatingBar.builder(
              initialRating: widget.makanan.saran!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 15,
              // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
                size: 1,
              ),
              ignoreGestures: true,
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          )
        ],
      ),
    );
  }
}
