import 'package:Attendance_Monitor/admin/features/dashboard/bloc/studentList_bloc/index.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/studentList_bloc/studentList_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/studentList_bloc/studentList_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/student.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/studentList_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    var dynamicHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => StudentListBloc(
        RepositoryProvider.of<StudentListRepository>(context),
      )..add(InitEvent()),
      child: BlocBuilder<StudentListBloc, StudentListState>(
        builder: (context, state) {
          if (state.status == StudentListStatus.loading) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "List of students",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _loading(dynamicHeight),
              ),
            );
          }
          if (state.status == StudentListStatus.success) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "List of students (${state.studentListModel.length.toString()})",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: state.studentListModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return studentCard(context, state, index);
                  },
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "List of students",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.start,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _failure(dynamicHeight),
            ),
          );
        },
      ),
    );
  }

  Widget studentCard(context, StudentListState state, int index) {

    var user = state.studentListModel[index];
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Student(user: user)),
          );
        },
        child: Row(
          children: [
             CircleAvatar(
              radius: 24,
              foregroundImage: NetworkImage( state.studentListModel[index].imageUrl.toString()),
              backgroundImage: const AssetImage('images/user.png'),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.studentListModel[index].name.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
                Text(
                  state.studentListModel[index].email.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.start,
                ),
              ],
            )
          ],
        ),
      ),
    );
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
              child: Icon(
                Icons.group_off,
                size: 180,
                color: Colors.white,
              ),
            ),
            Text(
              "Sorry, You do not any registered student yet!",
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
