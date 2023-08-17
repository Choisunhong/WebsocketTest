import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel channel;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {//웹소켓 연결 문제만 해결되면 나머지는 문제가 없어보입니다 한번만 체크 부탁드릴게요 
    super.initState();//지금 보이는 URI는 제가 보내는 메세지 그대로 다시 돌려주는 오픈 URI 입니다. 제가 이걸로 해봤을 떄 잘됬습니다. 
    channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));//시영님 여기다 URI조정하면됩니다.
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      channel.sink.add(_textController.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Chat App')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                } else {
                  return Text('No data received.');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}