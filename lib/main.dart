import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runa/screens/home.dart';
import 'package:runa/screens/masakan.dart';
import 'package:runa/screens/submit.dart';
import 'package:runa/screens/uploadmakanan.dart';
import 'package:runa/services/api/auth.dart';
import 'package:runa/services/api/makanan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  // TextEditingController _nameController = TextEditingController();

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
            MaterialButton(
              // color: _nameController.text.length > 1 ? Colors.blue : Colors.blueGrey.shade700,
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              minWidth: MediaQuery.of(context).size.width * 50 / 100,
              // onPressed: () => _nameController.text.length > 1 ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(name: _nameController.text,))) : _showAlert("jangan lupa isi namamu dulu ya"),
              onPressed: () async {
                await AuthServices.signInWithGoogle().then(
                        (value) => value['status'] == 200 ? {
                          (value['credential'] as UserCredential).user!.email == 'much.20058@mhs.unesa.ac.id'
                              || (value['credential'] as UserCredential).user!.email == 'dita.20020@mhs.unesa.ac.id'
                              || (value['credential'] as UserCredential).user!.email == 'shabian.20032@mhs.unesa.ac.id'
                              ?
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    AdminMenu(credential: value['credential'] as UserCredential))),
                            _showAlert(
                                'Anda Terdaftar Sebagai Admin, logging in ..', Colors.teal)
                          } : {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    HomeScreen(name: (value['credential'] as UserCredential).user!.displayName ?? 'User',))),
                            _showAlert(
                                'Welcome ${(value['credential'] as UserCredential).user!.displayName}', Colors.blue)
                          }
                        } : {
                          _showAlert('Terjadi kesalahan, mohon coba beberapa saat', Colors.amber.shade700)
                        });
              },
              child: Text("Start Runa's AI"),
            ),
            // MaterialButton(
            //   // color: _nameController.text.length > 1 ? Colors.blue : Colors.blueGrey.shade700,
            //   color: Colors.blue,
            //   textColor: Colors.white,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12)
            //   ),
            //   minWidth: MediaQuery.of(context).size.width * 50 / 100,
            //   // onPressed: () => _nameController.text.length > 1 ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(name: _nameController.text,))) : _showAlert("jangan lupa isi namamu dulu ya"),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) => Submit()));
            //   },
            //   child: Text("Cari makanan"),
            // ),
          ],
        ),
      )
    );
  }
}

class AdminMenu extends StatelessWidget {
  final UserCredential credential;
  const AdminMenu({Key? key, required this.credential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Halo Admin ${credential.user!.displayName}\nBerikut menu untuk anda : '),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                minWidth: MediaQuery.of(context).size.width * 50 / 100,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        MakananUpload())),
                child: Text("Tambahkan Makanan"),
              ),
              SizedBox(
                height: 5,
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                minWidth: MediaQuery.of(context).size.width * 50 / 100,
                onPressed: () async => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Submit())) ,
                child: Text("Test"),
              ),
              SizedBox(
                height: 5,
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                minWidth: MediaQuery.of(context).size.width * 50 / 100,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        HomeScreen(name: credential.user!.displayName ?? 'Admin',))),
                child: Text("Start Runa's AI"),
              ),
              SizedBox(height: 35,),
              MaterialButton(
                color: Colors.blueGrey.shade600,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                minWidth: MediaQuery.of(context).size.width * 50 / 100,
                onPressed: () async => await AuthServices.signOut().then((value) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OpeningPage()))),
                child: Text("Log out"),
              ),
            ],
          ),
        )
    );
  }
}

