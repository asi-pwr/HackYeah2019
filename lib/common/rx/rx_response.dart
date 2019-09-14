import 'rx_status.dart';

class RxResponse<T> {

  final T data;
  final Exception exception;
  final RxStatus status;

  RxResponse(this.status, {this.data, this.exception});
}
