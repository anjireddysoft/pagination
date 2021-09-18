import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'models/data_model.dart';

class APIService {
  Future<List<ItemModel>> getData(pageNumber) async {
    String url = "/repos?page=$pageNumber&per_page=15";

    print("URL : $url");

    final response = await http.get(Uri.parse(Config.apiURL + url));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);

      List<ItemModel> items =
          list.map((model) => ItemModel.fromJson(model)).toList();

      return items;
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
