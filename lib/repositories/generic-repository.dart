import 'package:sqflite/sqflite.dart';
import '../services/database-provider.dart';

class GenericRepository{
  Database database;

  Future checkDB() async{
    if(database == null || (database.isOpen == false)){
      database =  await DatabaseProvider.getDatabase();
      if(!database.isOpen){
        throw Exception("Error openeing database !");
      }
    }
  }
}