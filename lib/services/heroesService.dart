import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:marvel_heroes/models/Character.dart';

const baseUrl = "gateway.marvel.com:443";
const publicKey = "1f69feb2abcfa1a5a350d8adf05796f2";
const privateKey = "8a20021721b5fc67bd16517d761b73955a339e82";
Map<String, dynamic> params = {"apikey": publicKey};
String unencodedPath = '/v1/public/characters';

Future<List<dynamic>> fetchHeroes() async {
  params["ts"] = DateTime.now().millisecondsSinceEpoch.toString();
  params["hash"] = crypto.md5
      .convert(utf8.encode(params['ts'].toString() + privateKey + publicKey))
      .toString();
  try {
    var result = await http.get(Uri.https(baseUrl, unencodedPath, params));
    var heroObjsJson = json.decode(result.body)['data']['results'] as List;

    List<Character> heroObjs =
        heroObjsJson.map((heroJson) => Character.fromJson(heroJson)).toList();
    return heroObjs;
  } catch (Error) {
    print(Error);
  }
  return null;
}
