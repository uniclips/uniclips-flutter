import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, String> get headers => {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTg4ODU3MDUsInVzZXJJZCI6IjI4Y2YzZmRjLTk1NWMtNDc0YS04OTg1LTNjMWNjMmRjNjcxZiIsInVzZXJuYW1lIjoiZGlvIn0.BLJ9Vndl-TpNVqew8bwRa8uksyEBR04yeeli5kPmlOI",
    };

class Response<T> {
  T data;

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

  return data.data;
}

class AuthData {
  String token = "";
  String refreshToken = "";

  AuthData({required this.token, required this.refreshToken});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}

Future<AuthData> login(String username, String password) async {
  final response = await http
      .post(Uri.parse('http://13.229.126.140:3000/auth/login'), body: {
    "username": username,
    "password": password,
  });

  if (response.statusCode != 200) {
    throw Exception("Invalid username or password");
  }

  final Response resp = Response.fromJson(json.decode(response.body));
  final AuthData data = AuthData.fromJson(resp.data);

  return data;
}
