import 'package:http/http.dart';
import 'package:http/io_client.dart';

class RestIOClient extends IOClient {
  Duration timeout;
  RestIOClient([inner]) : super(inner);
  Future<StreamedResponse> send(BaseRequest request) async {
    return timeout != null
        ? super.send(request).timeout(timeout)
        : super.send(request);
  }
}