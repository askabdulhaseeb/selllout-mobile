// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

class PaypalServices {
  final String clientId, secretKey;
  final bool sandboxMode;
  PaypalServices({
    required this.clientId,
    required this.secretKey,
    required this.sandboxMode,
  });

  getAccessToken() async {
    String domain = sandboxMode
        ? "https://api.sandbox.paypal.com"
        : "https://api.paypal.com";
    try {
      var client = BasicAuthClient(clientId, secretKey);
      var response = await client.post(
          Uri.parse("$domain/v1/oauth2/token?grant_type=client_credentials"));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return {
          'error': false,
          'message': "Success",
          'token': body["access_token"]
        };
      } else {
        return {
          'error': true,
          'message': "Your PayPal credentials seems incorrect"
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': "Unable to proceed, check your internet connection."
      };
    }
  }

  Future<Map> createPaypalPayment(transactions, accessToken) async {
    String domain = sandboxMode
        ? "https://api.sandbox.paypal.com"
        : "https://api.paypal.com";
    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return {};
      } else {
        return body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'error': false, 'message': "Success", 'data': body};
      } else {
        return {
          'error': true,
          'message': "Payment inconclusive.",
          'data': body
        };
      }
    } catch (e) {
      return {'error': true, 'message': e, 'exception': true, 'data': null};
    }
  }
}

class BasicAuthClient extends http.BaseClient {
  /// The username to be used for all requests
  final String username;

  /// The password to be used for all requests
  final String password;

  final http.Client _inner;
  final String _authString;

  /// Creates a client wrapping [inner] that uses Basic HTTP auth.
  ///
  /// Constructs a new [BasicAuthClient] which will use the provided [username]
  /// and [password] for all subsequent requests.
  BasicAuthClient(this.username, this.password, {http.Client? inner})
      : _authString = _getAuthString(username, password),
        _inner = inner ?? http.Client();

  static String _getAuthString(String username, String password) {
    final token = base64.encode(latin1.encode('$username:$password'));

    final authstr = 'Basic ' + token.trim();

    return authstr;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = _authString;

    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}
