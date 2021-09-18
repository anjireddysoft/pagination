import 'package:floor/floor.dart';
import 'package:pagination_flutter/dao/itemmodel_dao.dart';
import 'package:pagination_flutter/models/data_model.dart';
import 'package:pagination_flutter/models/owner.dart';

@Database(version: 1, entities: [ItemModelData])
abstract class AppDatabase extends FloorDatabase{
  ItemModelDao get itemModelDao;
}