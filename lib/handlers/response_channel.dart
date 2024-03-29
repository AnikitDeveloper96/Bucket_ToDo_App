// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'custom_exceptions.dart';

// class ResponseChannel {
//   Future<dynamic> doPatch(String apiEndPoint, dynamic _body) async {
// /*    Map<String, dynamic> mapData = Map<String, dynamic>.from(tokenData);
//     final authToken = mapData["Authorization"];*/
//     // try {
//     final http.Response response = await http.patch(Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
// //          'Authorization': authToken,
//         },
//         body: _body);
//     return _returnResponse(response);
//   }

//   Future<dynamic> doPost(String apiEndPoint, dynamic body) async {
//     String? accessToken = await getAccessToken();

//     print("AccessToken: $accessToken");

//     final http.Response response = await http.post(Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'access-token': accessToken ?? "",
//         },
//         body: body);

//     return _returnResponse(response);
//   }

//   Future<dynamic> doPostAccessToken(
//       String apiEndPoint, dynamic body, String accessToken) async {
//     /* print("Api: $apiEndPoint");
//     print("Api: $body");
//     print("Api: $accessToken"); */

//     final http.Response response = await http.post(Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'access-token': accessToken,
//         },
//         body: body);
//     //print("ResponseChannel $apiEndPoint-----> ${response.body}");
//     return _returnResponse(response);
//   }

//   Future<dynamic> doBookSlotPost(String apiEndPoint, dynamic _body) async {
//     //print("Api Body: $_body");

//     final http.Response response = await http.post(Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: _body);
//     return _returnResponse(response);
//   }

//   Future<dynamic> doInstantBookSlotPost(
//       String apiEndPoint, dynamic _body) async {
//     //print("Api Body: $_body");

//     final http.Response response = await http.post(Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: _body);
//     return _returnResponse(response);
//   }

//   Future<dynamic> doPut(String apiEndPoint, dynamic _body) async {
//     var responseJson = "";

//     try {
//       final http.Response response = await http.put(Uri.parse(apiEndPoint),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
// //            'Authorization': authToken,
//           },
//           body: _body);
//       responseJson = _returnResponse(response, decode: 0);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }

//     return responseJson;
//   }

//   Future<dynamic> doGet(String apiEndPoint) async {
//     var responseJson = "";

//     try {
//       final response = await http.get(
//         Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
// //          'Authorization': authToken,
//         },
//       );
//       responseJson = _returnResponse(response, decode: 0);
//       //print("Response Json: $responseJson");
//     } on SocketException {
//       responseJson = "";
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }

//   Future<dynamic> doGetAccessToken(
//       String apiEndPoint, String accessToken) async {
//     var responseJson = "";

//     try {
//       final response = await http.get(
//         Uri.parse(apiEndPoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'access-token': accessToken,
// //          'Authorization': authToken,
//         },
//       );
//       responseJson = _returnResponse(response, decode: 0);
//       //print("Response Json: $responseJson");
//     } on SocketException {
//       responseJson = "";
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }

//   dynamic jsonDecodeUtf8(List<int> codeUnits) =>
//       json.decode(utf8.decode(codeUnits));

//   dynamic _returnResponse(http.Response response, {int decode = 1}) {
//     final responseCode = response.statusCode;

//     if (response.body.contains("Auth token expired!")) {

//       // Fluttertoast.showToast(msg: "Session Expired! Kindly Re-Login.",
//       //     toastLength: Toast.LENGTH_SHORT,
//       //     gravity: ToastGravity.CENTER,
//       //     timeInSecForIosWeb: 1,
//       //     backgroundColor: Colors.red,
//       //     textColor: Colors.white,
//       //     fontSize: 16.0
//       // );

// //      clearPrefs();
// //      setOneTimeLogin(false);
// //      Phoenix.rebirth(NavigationService.navigationKey.currentContext!);
// //      Navigator.pushAndRemoveUntil(NavigationService.navigationKey.currentContext!, MaterialPageRoute(builder: (context) => const EnterDetailsScreen()), ModalRoute.withName(EnterDetailsScreen.routeName));
//     }

//     if (responseCode >= 200 && responseCode <= 404) {
//       if (response.body.isNotEmpty) {
//         if (decode == 0) {
//           return response.body;
//         }
//         return response;
//         var responseJson = jsonDecodeUtf8(response.bodyBytes);
//         return responseJson;
//       } else {
//         return "";
//       }
//     } else if (responseCode == 400) {
//       throw BadRequestException(httpExceptionMessage(response));
//     } else if (responseCode == 422) {
//       throw UnProcessableException(httpExceptionMessage(response));
//     } else if (responseCode == 401 || responseCode == 403) {
//       throw UnauthorisedException(httpExceptionMessage(response));
//     } else if (responseCode == 404) {
//       Map<String, dynamic> responseMap = json.decode(response.body);
//       if (responseMap["success"] == "false" &&
//           responseMap["message"] == "No Record found") {
//         return response.body;
//       }

//       throw NotFoundException(httpExceptionMessage(response));
//     } else {
//       print(httpExceptionMessage(response));
//       print(responseCode);
//       //throw FetchDataException('Error occurred while Communicating with Server');
//     }
//   }

//   String httpExceptionMessage(http.Response response) {
//     var responseJson = json.decode(response.body.toString());
//     /* print("json.decode(response.body.toString())");
//     print('responseJson $responseJson'); */
//     return responseJson["false"];
//     //return responseJson["error"];
//   }

//   checkStatus200(int statusCode) {}
// }
