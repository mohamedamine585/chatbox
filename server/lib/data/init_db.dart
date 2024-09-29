import 'package:postgres/postgres.dart';

class PgConnect{
  static late Connection connection;
  initConnection()async{
 connection = await Connection.open(
  
  Endpoint(
  host: 'localhost', // Your PostgreSQL host
   port: 5432, // Your PostgreSQL port (default is 5432)
   database: 'chatbox', // Your database name
  username: 'mohamedamine', // Your PostgreSQL username
  password: 'med123', // Your PostgreSQL password)
),settings: ConnectionSettings(sslMode: SslMode.disable));

  }
  
  Future<void> closeConnection() async {
    await PgConnect.connection.close();
  }

}