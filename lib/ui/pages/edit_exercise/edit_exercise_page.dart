import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout_timer_app/data/model/workout_model.dart';

import '../../blocs/workout/workouts_cubit.dart';
import '../../utills/helper.dart';

class EditExercisePage extends StatefulWidget {
  final WorkoutModel? workout;
  final int index;
  final int? exIndex;

  const EditExercisePage(
      {Key? key,
      required this.workout,
      required this.index,
      required this.exIndex})
      : super(key: key);

  @override
  State<EditExercisePage> createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  TextEditingController? _title;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.workout!.exercises[widget.exIndex!].title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        final controller = TextEditingController(
                          text: widget.workout!.exercises[widget.exIndex!].prelude!.toString()
                        );
                        return AlertDialog(
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              labelText: "Prelude (seconds)"
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  Navigator.pop(context);
                                  setState(() {
                                    widget.workout!.exercises[widget.exIndex!]
                                    = widget.workout!.exercises[widget.exIndex!].copyWith(
                                        prelude: int.parse(controller.text)
                                    );
                                    context.read<WorkoutsCubit>().saveWorkout(widget.workout!, widget.index);

                                  });
                                }  
                              },
                              child: const Text("Save"),
                            )
                          ],
                        );

                      },
                  );
                },
                child: NumberPicker(
                  itemHeight: 30,
                  value: widget.workout!.exercises[widget.exIndex!].prelude!,
                  minValue: 0,
                  maxValue: 2999,
                  textMapper: (numberText) => formatedTime(int.parse(numberText), false),
                  onChanged: (value) {
                    setState(() {
                      widget.workout!.exercises[widget.exIndex!]
                      = widget.workout!.exercises[widget.exIndex!].copyWith(
                          prelude: value
                      );
                      context.read<WorkoutsCubit>().saveWorkout(widget.workout!, widget.index);

                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _title,
                onChanged: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!]
                  = widget.workout!.exercises[widget.exIndex!].copyWith(
                    title: value
                  );
                  context.read<WorkoutsCubit>().saveWorkout(widget.workout!, widget.index);
                }),
              ),
            ),
            Expanded(
              child: InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      final controller = TextEditingController(
                          text: widget.workout!.exercises[widget.exIndex!].duration!.toString()
                      );
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              labelText: "Duration (seconds)"
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                Navigator.pop(context);
                                setState(() {
                                  widget.workout!.exercises[widget.exIndex!]
                                  = widget.workout!.exercises[widget.exIndex!].copyWith(
                                      duration: int.parse(controller.text)
                                  );
                                  context.read<WorkoutsCubit>().saveWorkout(widget.workout!, widget.index);
                                  print('...I have ${widget.index} states');

                                });
                              }
                            },
                            child: const Text("Save"),
                          )
                        ],
                      );

                    },
                  );
                },
                child: NumberPicker(
                  itemHeight: 30,
                  value: widget.workout!.exercises[widget.exIndex!].duration!,
                  minValue: 0,
                  maxValue: 2999,
                  textMapper: (numberText) => formatedTime(int.parse(numberText), false),
                  onChanged: (value) {
                    setState(() {
                      widget.workout!.exercises[widget.exIndex!]
                      = widget.workout!.exercises[widget.exIndex!].copyWith(
                          duration: value
                      );
                      context.read<WorkoutsCubit>().saveWorkout(widget.workout!, widget.index);

                    });
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
