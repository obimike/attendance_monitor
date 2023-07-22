import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/classDetails_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/classDetails_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/index.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/classDetails_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassDetail extends StatelessWidget {
  const ClassDetail({super.key});

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => ClassDetailsBloc(
              RepositoryProvider.of<ClassDetailsRepository>(context),
            )..add(InitEvent()),
        child: BlocBuilder<ClassDetailsBloc, ClassDetailsState>(
            builder: (context, state) {
          if (state.status == ClassDetailsStatus.loading) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Class detail",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _loading(deviceHeight),
              ),
            );
          }

          if (state.status == ClassDetailsStatus.success) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Class detail",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: dynamicWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Class Name",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            state.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Class ID",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                            textAlign: TextAlign.start,
                          ),
                          SelectableText(
                            state.classID.toString(),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Class CheckIn Time",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            state.cit,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Class CheckOut Time",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            state.cot,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Days of the week",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall,
                            textAlign: TextAlign.start,
                          ),
                          Wrap(
                            children: [
                              Text(
                                state.days.toString(),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Class detail",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _failure(deviceHeight),
              ),
            );



        }));
  }

  Widget _loading(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.8,
      child: const Center(
        child: SizedBox(
          height: 64,
          width: 64,
          child: CircularProgressIndicator(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  Widget _failure(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.8,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child:  Icon(Icons.error, size: 256, color: Colors.redAccent,),
            ),
             Text(
              "An Error has occurred \nCheck your connection and try again.",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 48),

          ],
        ),
      ),
    );
  }
}
