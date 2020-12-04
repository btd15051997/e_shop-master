
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
enum NavigationEvent{
  HomeStoreClickedEvent,
  SearchClickedEvent,
  MyOrdersClickedEvent,
  CartPageClickedEvent,
}
abstract class NavigationStates {

}

class SideBarNavigationBloc extends Bloc<NavigationEvent, NavigationStates>{

  @override
  // TODO: implement initialState
  NavigationStates get initialState => StoreHome();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvent event)async* {
    switch(event){
      case NavigationEvent.HomeStoreClickedEvent :
        yield StoreHome();
        break;

      case NavigationEvent.SearchClickedEvent :
        yield SearchProduct();
        break;

      case NavigationEvent.MyOrdersClickedEvent :
        yield MyOrders();
        break;

        case NavigationEvent.CartPageClickedEvent :
        yield CartPage();
        break;
    }
  }

}