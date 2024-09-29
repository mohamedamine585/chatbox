import 'package:chatserver/data/init_db.dart';
import 'package:chatserver/middlewares/jwt_middleware.dart';
import 'package:chatserver/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthRepository{



 static Future<String?> signin({required String email, required String password})async{
  try {
    final connection = PgConnect.connection;
    final result = await connection.execute(r'select id,joinedat,name from cuser where email = $1 and password = $2',parameters:[email,password] );
    if(result.isEmpty){
     return null;

    }
     final data = result.first.toColumnMap();
      print(data);
     return JWT({'id':data["id"],'timestamp':DateTime.now().toString()}).sign(SecretKey(JWTMiddleware.secretKey));
  } catch (e) {
    print(e);
  }
 } 
 static Future<String?> signup({required String email,required String name, required String password})async{
  try {
        final connection = PgConnect.connection;

  final dupUserResult =  await connection.execute(r'select email from cuser cu where cu.email = $1',parameters:[email] );
  if(dupUserResult.isNotEmpty)
    {
   
      print(dupUserResult.first.toColumnMap()["email"]);
      return null;
    }
    final result = await connection.execute(r'insert into cuser(email,name,password) values($1,$2,$3)',parameters:[email,name,password] );
      final afterInsert =  await connection.execute(r'select email from cuser cu where cu.email = $1',parameters:[email] );

     final data = afterInsert.first.toColumnMap();
     return JWT({'id':data["id"],'timestamp':DateTime.now().toString()}).sign(SecretKey(JWTMiddleware.secretKey));
  } catch (e) {
    print(e);
  }
 } 
}