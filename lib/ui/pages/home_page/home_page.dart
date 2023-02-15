import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';
import 'package:workout_timer_app/ui/blocs/exercise/exercise_cubit.dart';
import 'package:workout_timer_app/ui/blocs/workout/workouts_cubit.dart';
import 'package:workout_timer_app/ui/pages/work_in_progress/work_in_progress_page.dart';

import '../../utills/helper.dart';
import '../edit_workout_page/edit_workout_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<WorkoutsCubit>().getWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Workout"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.event_available)),
          IconButton(onPressed: null, icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WorkoutsCubit, List<WorkoutModel>>(
            builder: (context, workouts) {
              return ExpansionPanelList.radio(
                  children: workouts.map((workout) => ExpansionPanelRadio(
                      value: workout,
                      headerBuilder: (context, isExpanded) => ListTile(
                        visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: VisualDensity.maximumDensity
                        ),
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, EditWorkoutPage.routeName,
                                  arguments: EditWorkoutPage(workout: workout, index: workouts.lastIndexOf(workout))
                              );
                              context.read<ExerciseCubit>().editWorkout(workout, workouts.lastIndexOf(workout));
                              print(workouts.lastIndexOf(workout));
                            },

                            icon: const Icon(Icons.edit)
                        ),
                        trailing: Text(formatedTime(workout.getTotalTime(), true)),
                        onTap: () {
                          if (!isExpanded) {
                            context.read<ExerciseCubit>().startWorkout(workout);
                            Navigator.pushNamed(context, WorkInProgressPage.routeName);
                          }
                        },
                        title: Text(workout.title!),
                      ),
                      body: ListView.builder(
                        itemCount: workout.exercises.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final exercise = workout.exercises[index];
                          return ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: VisualDensity.maximumDensity
                            ),
                            leading: Text(formatedTime(exercise.prelude!, true)),
                            title: Text(exercise.title!),
                            trailing: Text(formatedTime(exercise.duration!, true)),

                          );
                        },
                      )
                  )).toList()
              );
            },
        ),
      ),
    );
  }
}
