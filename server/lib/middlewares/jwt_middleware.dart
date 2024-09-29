import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JWTMiddleware {
 static final String secretKey = 'KSFt61eAZWql7YAxIYXMQbhj7hCi4CirHjb_MSEuS_k=';


 static FutureOr<void> call(HttpRequest request, void Function() next) async {
    try {
      if(request.uri.path.startsWith('/auth')){
        return next();
      }
      final authHeader = request.headers.value(HttpHeaders.authorizationHeader);
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        _unauthorized(request);
        return;
      }

      final token = authHeader.substring(7); // Extract token after "Bearer "

      try {
        final jwt = JWT.verify(token, SecretKey(secretKey));
        request.response.headers.add('x-user',jwt.payload['id']);

        next();
      } catch (e) {
        print('JWT verification error: $e');
        _unauthorized(request);
      }
    } catch (e) {
      print('Middleware error: $e');
      _unauthorized(request);
    }
  }

 static void _unauthorized(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.unauthorized
      ..write('Unauthorized')
      ..close();
  }
 static String generateToken(String secretKey, Map<String, dynamic> payload) {
  // Create a JWT with the provided payload and expiration time
  final jwt = JWT(payload);

  // Sign the JWT with the secret key
  final token = jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS256);

  return token;
}
}

