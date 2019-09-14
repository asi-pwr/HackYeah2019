import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final compositeSubscription = new CompositeSubscription();

  void dispose(){
    compositeSubscription.dispose();
  }
}