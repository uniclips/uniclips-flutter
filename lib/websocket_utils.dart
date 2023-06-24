import 'package:web_socket_channel/web_socket_channel.dart';

class MessageUtils {
  static WebSocketChannel? _webSocket;

  static void connect(String token) {
    _webSocket = WebSocketChannel.connect(
        Uri.parse("ws://13.229.126.140:3000/ws/clipboard?token=$token"));

    void onData(dynamic content) {
      _sendMessage(content);
    }

    _webSocket?.stream.listen(onData,
        onError: (a) => print("error"), onDone: () => print("done"));
  }

  static void closeSocket() {
    _webSocket?.sink.close();
  }

  static void _sendMessage(String message) {
    _webSocket?.sink.add(message);
  }
}
