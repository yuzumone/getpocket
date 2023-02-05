import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:getpocket/data/model/item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher_string.dart';

final clientPrivider = Provider((ref) => Client());

final pocketRepositoryProvider =
    Provider((ref) => PocketRepository(client: ref.read(clientPrivider)));

class PocketRepository {
  static const consumerKey = bool.hasEnvironment('POCKET_CONSUMER_KEY')
      ? String.fromEnvironment('POCKET_CONSUMER_KEY')
      : '';
  static const redirectUri = bool.hasEnvironment('POCKET_REDIRECT_URI')
      ? String.fromEnvironment('POCKET_REDIRECT_URI')
      : '';
  static const requestEndpoint = 'https://getpocket.com/v3/oauth/request';
  static const redirectUserEndpoint = 'https://getpocket.com/auth/authorize';
  static const authorizeEndpoint = 'https://getpocket.com/v3/oauth/authorize';
  final Client client;

  PocketRepository({required this.client});

  Future<Stream<bool>> _server() async {
    final onResult = StreamController<bool>();
    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((request) async {
      request.response
        ..statusCode = 200
        ..headers.set('Content-Type', ContentType.html.mimeType)
        ..write('close this window');
      await request.response.close();
      await server.close(force: true);
      onResult.add(true);
      await onResult.close();
    });
    return onResult.stream;
  }

  Future<String> _getCode() async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Accept': 'application/json'
    };
    final param = {
      'consumer_key': consumerKey,
      'redirect_uri': redirectUri,
    };
    var res = await client.post(Uri.parse(requestEndpoint),
        headers: headers, body: json.encode(param));
    return json.decode(res.body)['code'];
  }

  Future<String> _getToken(String code) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Accept': 'application/json'
    };
    final param = {
      'consumer_key': consumerKey,
      'code': code,
    };
    var res = await client.post(Uri.parse(authorizeEndpoint),
        headers: headers, body: json.encode(param));
    return json.decode(res.body)['access_token'];
  }

  Future<String> getAccessToken() async {
    final code = await _getCode();
    var onResult = await _server();
    var url =
        '$redirectUserEndpoint?request_token=$code&redirect_uri=$redirectUri';
    await launchUrlString(url, mode: LaunchMode.externalApplication);
    await onResult.first;
    var token = await _getToken(code);
    return token;
  }

  Future<List<Item>> getPocketItems(String token, {String count = '50'}) async {
    final headers = {'Content-Type': 'application/json'};
    final params = {
      'consumer_key': consumerKey,
      'access_token': token,
      'count': count,
      'detailType': 'simple',
    };
    final uri = Uri.https('getpocket.com', '/v3/get', params);
    var res = await client.get(uri, headers: headers);
    if (res.statusCode < 300) {
      final list = json.decode(res.body)['list'];
      final items = list.values
          .map((value) => Item.fromJson(value))
          .whereType<Item>()
          .toList();
      return items;
    } else {
      return [];
    }
  }

  Future<bool> archivePocketItems(List<Item> items, String token) async {
    final actions = <Map<String, String>>[];
    for (var e in items) {
      actions.add({
          'action': 'archive',
          'item_id': e.itemId,
        });
    }
    final params = {
      'actions': json.encode(actions),
      'consumer_key': consumerKey,
      'access_token': token,
    };
    final uri = Uri.https('getpocket.com', '/v3/send', params);
    var res = await client.get(uri);
    if (res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }
}
