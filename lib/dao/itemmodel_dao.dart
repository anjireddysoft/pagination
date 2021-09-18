
import 'package:floor/floor.dart';
import 'package:pagination_flutter/models/data_model.dart';
import 'package:pagination_flutter/models/owner.dart';

@dao
abstract class ItemModelDao {
  @insert
  Future<void> insertData(ItemModelData ItemModelData);

  @Query('SELECT * FROM ItemModelData')
  Future<List<ItemModelData>> getData();

}