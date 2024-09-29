import 'package:chatserver/models/user.dart';

class ChatMate {
   final User user;
    bool isBlackListed = false;
    Role role;
   final DateTime joinedAt = DateTime.now();
    int reputation = 0;

   ChatMate({required this.user , required this.role , required this.reputation}){
    if(this.reputation == 0){
    if(this.role == Role.ADMIN){
     this.reputation = 10;
    }else{
      this.reputation = 1;
    }
    }
  
   }
   
}

enum Role {
    ADMIN,
    MEMBER,
    SPECTATOR,
}
String roleToString(Role role){
  switch (role) {
    case Role.ADMIN:
     return 'ADMIN';
    case Role.SPECTATOR:
    return 'SPECTATOR';

    default:
     return  'MEMBER';
  }
}