import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:runa/screens/masakan.dart';
import 'package:runa/services/api/makanan.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:runa/screens/submit.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String logState = "Coba ucap 'hai!\natau tahan dan tekan untuk manual'";
  FlutterTts flutterTts = FlutterTts();
  bool makananRingan = false;
  bool order = false;
  List<String> bahan = [];
  bool goreng = false;

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  double shadowRadius = 0.0;


  runasShadowSet(double value){
    if(value > 0 && value < 15){
      setState(() {
        shadowRadius = value;
      });
    }
  }

  logStateSet(String value){
    setState(() {
      logState = value;
    });
  }

  /// This has to happen only once per app
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "id",
        listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  Future<void> _beginConversation() async {
    setState(() {
      _speechEnabled = true;
      logStateSet("Runa Mendengarkanmu");
    });
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "id",
        onSoundLevelChange: (value){
          runasShadowSet(value);
          print("Level Value "+value.toString());
        },
        listenMode: ListenMode.dictation,
        listenFor: Duration(seconds: 30)
    );
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _speechEnabled = false;
      shadowRadius = 0;
      logState = "Ketuk untuk membangunkan runa";
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    print("Voice Recognition Started");
    setState(() {
      _lastWords = result.recognizedWords;
    });
    if(_lastWords.length > 10 && order && _lastWords.toLowerCase() == "iya punya"){
      setState(() {
        bahan.add("minyak goreng");
        goreng = true;
      });
      String question = "Oke, aku mempunyai beberapa saran makanan";
      _speak(question);
      makananSuggestion(makananRingan, bahan, goreng ? 'digoreng' : 'ditumis');
    }
    if(order == true && _lastWords.length > 5){
      List<String> b = _lastWords.split(' ');
      setState(() {
        bahan = b;
      });
      String question = "Apakah kamu mempunyai minyak goreng?";
      await _speak(question).then((value) => _beginConversation());
    }
    if(_lastWords.toLowerCase() == "aku ingin makanan berat"){
      setState(() {
        makananRingan = false;
        order = true;
      });
      String dependency = "Sebutkan bahan-bahan makanan yang kamu punya, kecuali minyak goreng";
      await _speak(dependency);
      _beginConversation();
    }
    if(_lastWords.toLowerCase() == "aku ingin makanan ringan"){
      setState(() {
        makananRingan = true;
        order = true;
      });
      String dependency = "Sebutkan bahan-bahan makanan yang kamu punya, kecuali minyak goreng";
      await _speak(dependency);
      _beginConversation();
    }
    if(_lastWords.toLowerCase() == "iya makanan ringan"){
      setState(() {
        makananRingan = true;
        order = true;
      });
      String dependency = "Sebutkan bahan-bahan makanan yang kamu punya, kecuali minyak goreng";
      await _speak(dependency);
      _beginConversation();
    }
    if(_lastWords.toLowerCase() == "hai"){
      setState(() {
        bahan = [];
        order = false;
      });
      await _speak("Halo ${widget.name}");
      String question = "Apakah kamu ingin makanan ringan?";
      logStateSet(question);
      await _speak(question);
      _beginConversation();
    }else{
      setState(() {
        _speechEnabled = false;
      });
      logStateSet("Ketuk untuk membangunkan runa");
      runasShadowSet(0);
    }
    if(_lastWords.toLowerCase() == "apa yang harus aku lakukan sekarang" && !order){
      await _speak("Tidur");
      _beginConversation();
      // _stop();
    }
    if(_lastWords.toLowerCase() == "baiklah" && !order){
      await _speak("Selamat Tidur!");
      logStateSet("Ketuk untuk membangunkan runa");
      runasShadowSet(0);
      setState(() {
        _speechEnabled = false;
      });
    }

    if(_lastWords.toLowerCase() == "nice" && !order){
      await _speak("Hari ini menyenangkan ya!");
      logStateSet("Ketuk untuk membangunkan runa");
      runasShadowSet(0);
      setState(() {
        _speechEnabled = false;
      });
      willPop();
    }

    if(_lastWords.toLowerCase() == "telur minyak goreng garam" && !order){
      await _speak("Telor Ceplok pas buat kamu!");
      logStateSet("Ketuk untuk membangunkan runa");
      runasShadowSet(0);
      setState(() {
        _speechEnabled = false;
      });
      makananSuggestion(true, ['telur', 'minyak goreng', 'garam'], 'digoreng');
    }

  }

  double height(double heightPrecentage){
    return heightPrecentage / 100 * MediaQuery.of(context).size.height;
  }
  double width(double widthPrecentage){
    return widthPrecentage / 100 * MediaQuery.of(context).size.width;
  }

  Future _speak(String value) async{
    logStateSet(value);
    await flutterTts.speak(value);
    // await _stop();
  }

  Future _stop() async{
    var result = await flutterTts.stop();
    if (result == 1) setState(() => _speechEnabled = false);
    logStateSet("Runa Mendengarkanmu");
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInitRecognition();
    flutterTts.setStartHandler(() {
      ///This is called when the audio starts
      onInitSpeak();
    });

    flutterTts.setCompletionHandler(() {
      _stop();
      logStateSet("Ketuk untuk berbicara");
    });
  }

  onInitRecognition() async {
    await _initSpeech();
    await _startListening();
  }
  onInitSpeak() async {
    // await flutterTts.setLanguage("in-ID");
    // await flutterTts.isLanguageAvailable("in-ID");
    await flutterTts.setQueueMode(1);
    await flutterTts.setVolume(1.0);
  }

  restartListeningwords(){
    if(_speechEnabled == false){
      _beginConversation();
    }


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_speechEnabled == true){
      _speechEnabled = false;
      shadowRadius = 0;
      logState = "Ketuk untuk membangunkan runa";
      _speechToText.stop();
    }
  }

  Future<void> makananSuggestion(bool isRingan, List<String> bahan, String caraMasak) async {
    setState(() {
      _speechEnabled = false;
      shadowRadius = 0;
      logState = "Ketuk untuk membangunkan runa";
      _speechToText.stop();
    });
    await MakananApi.getRecommendedFoodRanking(isRingan, bahan, caraMasak)
        .then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakananList(makananRanked: value,))));
  }

  Future<bool> willPop() async {
    setState(() {
      _speechEnabled = false;
      shadowRadius = 0;
      logState = "Ketuk untuk membangunkan runa";
      _speechToText.stop();
    });
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            height: height(100),
            width: width(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Submit()));
                  },
                  onTap: _beginConversation,
                  child: Container(
                    width: width(50),
                    height: width(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: _speechEnabled ? Colors.blue : Colors.blueGrey,
                      boxShadow: [
                        BoxShadow(
                          color: _speechEnabled ? Colors.blueGrey : Colors.black12,
                          blurRadius: shadowRadius+10,
                          spreadRadius: shadowRadius+4,
                          offset: Offset(2, 0.5),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(logState, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height(20),),
                Text("Debuged words : "+_lastWords.toLowerCase())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
