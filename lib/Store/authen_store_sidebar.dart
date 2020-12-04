import 'package:e_shop/Bloc/bloc_sidebar.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenStoreAndSideBarLayout extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<SideBarNavigationBloc>(
          create: (context) => SideBarNavigationBloc(),
          child: Stack(
            children: [
              /*change state homestore*/
              BlocBuilder<SideBarNavigationBloc,NavigationStates>(
                builder: (context,navigationState){
                  return navigationState as Widget;
                },
              ),
              SideBar(),
            ],
          ),
        ),
      ),
    );
  }
}