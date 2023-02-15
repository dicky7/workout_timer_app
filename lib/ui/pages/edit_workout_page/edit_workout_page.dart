import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';
import 'package:workout_timer_app/ui/blocs/exercise/exercise_cubit.dart';
import 'package:workout_timer_app/ui/blocs/workout/workouts_cubit.dart';
import 'package:workout_timer_app/ui/pages/edit_exercise/edit_exercise_page.dart';
import 'package:workout_timer_app/ui/utills/helper.dart';

class EditWorkoutPage extends StatefulWidget {
  static const routeName = "edit_workout";
  final WorkoutModel workout;
  final int index;

  const EditWorkoutPage({Key? key, required this.workout, required this.index}) : super(key: key);

  @override
  State<EditWorkoutPage> createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExerciseCubit>().editWorkout(
          widget.workout,
          widget.workout.exercises.lastIndexOf(widget.workout.exercises.last)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        ExerciseEditing editing = state as ExerciseEditing;
        return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: InkWell(
                child: Text(editing.workout!.title!),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) {
                    final controller = TextEditingController(
                      text: editing.workout!.title!,
                    );
                    return AlertDialog(
                      content: TextField(
                        controller: controller,
                        decoration:
                        const InputDecoration(labelText: "Workout Title"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              Navigator.pop(context);
                              WorkoutModel renamed = editing.workout!.copywith(title: controller.text);
                              BlocProvider.of<WorkoutsCubit>(context).saveWorkout(renamed, widget.index);
                              BlocProvider.of<ExerciseCubit>(context).editWorkout(renamed, widget.index);
                            }
                          },
                          child: Text("Rename"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            body:  ListView.builder(
              itemCount: editing.workout!.exercises.length,
              itemBuilder: (context, index) {
                final exercise = editing.workout!.exercises[index];
                if (editing.exIndex == index) {
                  return EditExercisePage(
                      workout: editing.workout,
                      index: index,
                      exIndex: editing.exIndex);
                } else {
                  return ListTile(
                    leading: Text(formatedTime(exercise.prelude!, true)),
                    title: Text(exercise.title!),
                    trailing: Text(
                        formatedTime(exercise.duration!, true)),
                    onTap: () {
                      context.read<ExerciseCubit>().editExercise(index);
                    },
                  );
                }
              },
            )
        );
      },
    );
  }
}
