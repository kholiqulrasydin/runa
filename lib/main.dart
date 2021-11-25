import 'package:flutter/material.dart';
import 'package:runa/screens/home.dart';

void main() {
  runApp(Runa());
}

class Runa extends StatelessWidget {
  Runa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OpeningPage()
    );
  }
}

class OpeningPage extends StatefulWidget {
  const OpeningPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OpeningPage> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  TextEditingController _nameController = TextEditingController();

  _showAlert(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$msg',
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.amber.shade700,
    ));
  }

  double height(double heightPrecentage){
    return heightPrecentage / 100 * MediaQuery.of(context).size.height;
  }
  double width(double widthPrecentage){
    return widthPrecentage / 100 * MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: width(15), right: width(15), bottom: height(5)),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Isikan namamu",
                  hintText: "contoh : shabian",
                  suffixIcon: const Icon(Icons.person_outline_rounded),
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                scrollPhysics: const NeverScrollableScrollPhysics(),
              ),
            ),
            MaterialButton(
              color: _nameController.text.length > 1 ? Colors.blue : Colors.blueGrey.shade700,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              minWidth: MediaQuery.of(context).size.width * 50 / 100,
              onPressed: () => _nameController.text.length > 1 ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(name: _nameController.text,))) : _showAlert("jangan lupa isi namamu dulu ya"),
              child: Text("Start Runa's AI"),
            ),
          ],
        ),
      )
    );
  }
}
