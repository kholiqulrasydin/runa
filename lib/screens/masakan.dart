import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class MakananList extends StatelessWidget {
  MakananList({Key? key}) : super(key: key);
  List<Makanan> _makanans = [
    Makanan(imageUrl: "assets/telorceplok.jpg", uid: "8gbNhKhljs", nama: "Telor Ceplok", bahan: ["Telor", "Minyak Goreng", "Garam"], saran: 4.5),
    Makanan(imageUrl: "assets/telorceplok.jpg", uid: "7yBgDfkL56", nama: "Telor Dadar", bahan: ["Telor", "Minyak Goreng", "Garam"], saran: 4),
    Makanan(imageUrl: "assets/telorceplok.jpg", uid: "12CvbNmh79", nama: "Telor Dadar Daun Bawang", bahan: ["Telor", "Minyak Goreng", "Garam", "Daun Bawang"], saran: 3.5),
    Makanan(imageUrl: "assets/telorceplok.jpg", uid: "098nMtg&6j", nama: "Telor Gulung Sosis", bahan: ["Telor", "Minyak Goreng", "Garam", "Sosis"], saran: 3),
    Makanan(imageUrl: "assets/telorceplok.jpg", uid: "07BhgfDguk", nama: "Martabak", bahan: ["Telor", "Minyak Goreng", "Garam", "Daun Bawang", "Daging", "Kaldu / Penyedap", "Tepung Terigu"], saran: 2),
  ];

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
        child: ListView.builder(
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
              Image.asset(widget.makanan.imageUrl!, width: 50, height: 50,),
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

class Makanan{
  final String ? imageUrl;
  final String ? uid;
  final String ? nama;
  final List ? bahan;
  final double ? saran;

  Makanan({this.imageUrl, this.uid, this.nama, this.bahan, this.saran});
}
