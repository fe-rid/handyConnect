import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/handyman_repository.dart';
import 'data/repositories/request_repository.dart';
import 'data/mock/mock_auth_repository.dart';
import 'data/mock/mock_handyman_repository.dart';
import 'data/mock/mock_request_repository.dart';
import 'feature/auth/bloc/auth_cubit.dart';
import 'feature/handyman/bloc/handyman_cubit.dart';
import 'feature/requests/bloc/requests_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => MockAuthRepository()),
        Provider<HandymanRepository>(create: (_) => MockHandymanRepository()),
        Provider<RequestRepository>(create: (_) => MockRequestRepository()),
      ],
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) => AuthCubit(context.read<AuthRepository>())),
            BlocProvider(
                create: (_) =>
                    HandymanCubit(context.read<HandymanRepository>())),
            BlocProvider(
                create: (_) =>
                    RequestsCubit(context.read<RequestRepository>())),
          ],
          child: MaterialApp.router(
            title: 'HandyConnect',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          ),
        );
      }),
    );
  }
}
