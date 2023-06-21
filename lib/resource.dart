import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, String> get headers => {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTg4ODU3MDUsInVzZXJJZCI6IjI4Y2YzZmRjLTk1NWMtNDc0YS04OTg1LTNjMWNjMmRjNjcxZiIsInVzZXJuYW1lIjoiZGlvIn0.BLJ9Vndl-TpNVqew8bwRa8uksyEBR04yeeli5kPmlOI",
    };

class Response {
  final List<dynamic> data;

  Response({required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      data: json['data'],
    );
  }
}

Future<List<dynamic>> getClipboard() async {
  final response = await http
      .get(Uri.parse('http://13.229.126.140:3000/clipboard'), headers: headers);
  final Response data = Response.fromJson(json.decode(response.body));

  print(data.toString());

  return data.data;
}
