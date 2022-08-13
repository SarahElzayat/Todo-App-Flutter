import 'package:app1/shared/components/components.dart';
import 'package:app1/shared/cubit/cubit.dart';
import 'package:app1/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';


class HomeLayout extends StatelessWidget {
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      AppCubit()
        ..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertIntoDataState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppLoadingState,
              builder: ((context) => cubit.screens[cubit.currentIndex]),
              fallback: ((context) =>
              const Center(child: CircularProgressIndicator())),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDatabase(title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                        titleController.clear();
                        timeController.clear();
                        dateController.clear();
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.grey[150],
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFromField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Title must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task title',
                                    prefixIcon: Icons.title,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultFromField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task time',
                                    prefixIcon: Icons.watch_later_outlined,
                                    readOnly: true,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  defaultFromField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                          DateTime.parse('2022-12-30'))
                                          .then((value) {
                                        dateController.text = DateFormat.yMMMd()
                                            .format(value!)
                                            .toString();
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    prefixIcon: Icons.calendar_month_outlined,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(isShown: false, i: Icons.edit);
                  });

                  cubit.changeBottomSheetState(isShown: true, i: Icons.add);
                }
              },
              child: Icon(cubit.fab),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              // showSelectedLabels: false,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items:  [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu,size: 30,),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_outlined,size: 30,color: Colors.green[400],),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined,size: 30,),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
