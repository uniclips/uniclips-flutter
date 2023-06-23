import 'package:flutter/material.dart';
import 'package:rich_clipboard/rich_clipboard.dart';
import 'package:uniclip_mobile/resource.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> clipboards = [];

  final _channel = WebSocketChannel.connect(
    Uri.parse(
        'ws://13.229.126.140:3000/ws/clipboard?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTg4ODU3MDUsInVzZXJJZCI6IjI4Y2YzZmRjLTk1NWMtNDc0YS04OTg1LTNjMWNjMmRjNjcxZiIsInVzZXJuYW1lIjoiZGlvIn0.BLJ9Vndl-TpNVqew8bwRa8uksyEBR04yeeli5kPmlOI'),
  );

  buildClipboard() async {
    var data = await getClipboard();
    setState(() {
      clipboards = data;
    });
  }

  addClipboard(String text) {
    setState(() {
      clipboards = [text, ...clipboards];
    });
  }

  @override
  void initState() {
    super.initState();

    buildClipboard();

    _channel.stream.listen((message) {
      addClipboard(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> clipboardWidgets = [];
    if (clipboards.isNotEmpty) {
      for (var i = 0; i < clipboards.length; i++) {
        clipboardWidgets.add(Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
          child: TextButton(
              onPressed: () async {
                await RichClipboard.setData(RichClipboardData(
                  text: clipboards[i],
                ));
              },
              child: Text(clipboards[i])),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Ganti'),
            ),
            const SizedBox(height: 24),
            GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: clipboardWidgets,
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _pasteFromClipboard,
        tooltip: 'Paste From Clipboard',
        child: const Icon(Icons.content_paste),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _pasteFromClipboard() async {
    final clipboardData = await RichClipboard.getData();
    if (clipboardData.html != null) {
      // Do something with HTML
    } else if (clipboardData.text != null) {
      _channel.sink.add(clipboardData.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
