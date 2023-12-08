import 'package:premium_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc/cubit.dart';
import 'package:premium_fivver_note_app/shared/bloc_observer.dart';
import 'package:premium_fivver_note_app/shared/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Shared.init();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesCubit(),
        ),
        BlocProvider(
          create: (context) => AddNoteCubit()..createDB(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Harry',
          primarySwatch: Colors.grey,
        ),
        debugShowCheckedModeBanner: false,
        home: const LayoutScreen(),
      ),
    );
  }
}
