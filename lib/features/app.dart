import 'package:chatapp/core/utils/snack_bar.dart';
import 'package:chatapp/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../core/utils/di.dart';
import '../core/routes/routers.dart';
import 'auth/presentation/bloc/auth/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routers,
        scaffoldMessengerKey: scaffoldMessengerStateKey,
        builder: EasyLoading.init(),
      ),
    );
  }
}
