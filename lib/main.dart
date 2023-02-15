import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';
import 'package:workout_timer_app/ui/blocs/exercise/exercise_cubit.dart';
import 'package:workout_timer_app/ui/blocs/workout/workouts_cubit.dart';
import 'package:workout_timer_app/ui/pages/edit_workout_page/edit_workout_page.dart';
import 'package:workout_timer_app/ui/pages/home_page/home_page.dart';
import 'package:workout_timer_app/ui/pages/work_in_progress/work_in_progress_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WorkoutsCubit(),
        ),
        BlocProvider(
          create: (_) => ExerciseCubit(),
        )

      ],
      child: MaterialApp(
        title: 'My Workouts',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        initialRoute: HomePage.routeName,
        onGenerateRoute: (RouteSettings settings) {
          switch(settings.name) {
            case HomePage.routeName:
              return MaterialPageRoute(builder: (_) => const HomePage());
            case EditWorkoutPage.routeName:
              final args = settings.arguments as EditWorkoutPage;
              return MaterialPageRoute(builder: (_) => EditWorkoutPage(
                workout: args.workout,
                index: args.index,
              ));
            case WorkInProgressPage.routeName:
              return MaterialPageRoute(builder: (_) => const WorkInProgressPage());
            default: return MaterialPageRoute(builder: (_) {
              return const Scaffold(
                body: Center(
                  child: Text('Page not found :('),
                ),
              );
            });
          }
        },
      ),
    );
  }
}
