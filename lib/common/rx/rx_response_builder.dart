import 'package:flutter1/common/rx/rx_response.dart';
import 'package:flutter1/common/rx/rx_status.dart';

class RxResponseBuilder<T> {
  RxResponse<T> pending(){
    return RxResponse<T>(RxStatus.PENDING);
  }

  RxResponse<T> success(data){
    return RxResponse<T>(RxStatus.SUCCESS, data: data);
  }

  RxResponse<T> error(Exception e){
    return RxResponse<T>(RxStatus.ERROR, exception: e);
  }
}
