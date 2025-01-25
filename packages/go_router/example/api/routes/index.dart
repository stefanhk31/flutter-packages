import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  const html = '''
    <p>Hello from Dart Frog!</p>
  ''';

  return Response(body: html);
}
