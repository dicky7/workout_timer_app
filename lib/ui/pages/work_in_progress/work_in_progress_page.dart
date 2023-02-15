import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';
import 'package:workout_timer_app/ui/blocs/exercise/exercise_cubit.dart';
import 'package:workout_timer_app/ui/utills/helper.dart';

class WorkInProgressPage extends StatelessWidget {
  static const routeName = "/workInProgress";
  const WorkInProgressPage({Key? key}) : super(key: key);

  Map<String, dynamic> _getStats(WorkoutModel workout, int workoutElapsed ){
    int workTotal = workout.getTotalTime();
    Exercise exercise = workout.getCurrentExercise(workoutElapsed);
    int exerciseElapsed = workoutElapsed - exercise.startTime!;

    int exerciseRemaining = exercise.prelude! - exerciseElapsed;
    bool isPrelude = exerciseElapsed < exercise.prelude!;
    int exerciseTotal = isPrelude ? exercise.prelude! : exercise.duration!;

    if (!isPrelude) {
      exerciseElapsed -= exercise.prelude!;
      exerciseRemaining += exercise.duration!;
    }


    return{
      "workoutTitle": workout.title,
      "workoutProgress": workoutElapsed/workTotal,
      "workoutElapsed": workoutElapsed,
      "totalExercise": workout.exercises.length,
      "currentExerciseIndex": exercise.index!.toDouble(),
      "workoutRemaining": workTotal - workoutElapsed,
      "exerciseRemaining": exerciseRemaining,
      "exerciseProgress": exerciseElapsed/exerciseTotal,
      "isPrelude": isPrelude
    };
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExerciseCubit, ExerciseState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final stats = _getStats(state.workout!, state.elapsed!);
        return Scaffold(
          appBar: AppBar(
            title: Text(state.workout!.title.toString()),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.blue[100],
                  minHeight: 10,
                  value: stats["workoutProgress"],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatedTime(stats["workoutElapsed"], true)
                      ),
                      DotsIndicator(
                          dotsCount: stats["totalExercise"],
                        position: stats["currentExerciseIndex"],
                      ),
                      Text("-${formatedTime(stats["workoutRemaining"], true)}")
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (state is WorkoutInProgress) {
                      context.read<ExerciseCubit>().pauseWorkout();
                    } else if (state is WorkoutPause){
                      context.read<ExerciseCubit>().resumeWorkout();
                    }
                  },
                  child: Stack(
                    alignment: const Alignment(0,0),
                    children: [
                      Center(
                        child: SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              stats["isPrelude"] ?Colors.red : Colors.blue
                            ),
                            strokeWidth: 25,
                            value: stats["exerciseProgress"],
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset("assets/stopwatch.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
