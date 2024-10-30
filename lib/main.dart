import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String words = '';

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  initPlugin() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startRecording() {
    _speechToText.listen(
      onResult: _onResult,
    );
    setState(() {});
  }

  void _stopRecording() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onResult(SpeechRecognitionResult result) {
    words = result.recognizedWords;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Speak to Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              words.isNotEmpty
                  ? words
                  : _speechEnabled
                      ? 'Clique no botao para comecar a ouvir'
                      : 'Reconhecimento de fala através de texto nao disponivel',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopRecording : _startRecording,
        tooltip:
            _speechToText.isListening ? 'Parar de ouvir ' : 'Comecar a ouvir',
        child: Icon(
          _speechToText.isListening ? Icons.mic_off : Icons.mic,
        ),
      ),
    );
  }
}
