/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;

// Replace this with the server host you create, if you have your own server running
// e.g. https://server-host.com
String chargeServerHost = "REPLACE_ME";
String chargeUrl = "$chargeServerHost/chargeForCookie";

class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}

Future<void> chargeCard(CardDetails result) async {
  var body = jsonEncode({"nonce": result.nonce});
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
  } on SocketException catch (e) {
    throw ChargeException(e.message.toString());
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return;
  } else {
    throw ChargeException(responseBody["errorMessage"]);
  }
}
