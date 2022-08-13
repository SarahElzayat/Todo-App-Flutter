import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: ((context, state) {}),
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return BlocConsumer<AppCubit, AppStates>(
          listener: ((context, state) {}),
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return ConditionalBuilder(
              condition: cubit.doneTasks.isNotEmpty,
              builder: (context) => ListView.separated(
                  itemBuilder: (context, index) {
                    return buildTaskItem(cubit.doneTasks[index], context);
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(start: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    );
                  },
                  itemCount: cubit.doneTasks.length),
              fallback: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 50,
                      color: Colors.green[400],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No tasks available',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
