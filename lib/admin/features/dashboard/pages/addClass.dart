import 'package:Attendance_Monitor/admin/features/dashboard/bloc/addClass_bloc/addClass_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/addClass_bloc/index.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/dashboard.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/addClass_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';

import '../bloc/addClass_bloc/addClass_event.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  late TimeOfDay _selectedCheckInTime, _selectedCheckOutTime;

  Future<void> _selectCheckInTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedCheckInTime,
    );

    if (pickedTime != null && pickedTime != _selectedCheckInTime) {
      setState(() {
        _selectedCheckInTime = pickedTime;
        context.read<AddClassBloc>().add(
            CheckInTimeChangedEvent(cit: _selectedCheckInTime.format(context)));
      });
    }
  }

  Future<void> _selectCheckOutTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedCheckOutTime,
    );

    if (pickedTime != null && pickedTime != _selectedCheckOutTime) {
      setState(() {
        _selectedCheckOutTime = pickedTime;
        context.read<AddClassBloc>().add(CheckOutTimeChangedEvent(
            cot: _selectedCheckOutTime.format(context)));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedCheckInTime = TimeOfDay.now();
    _selectedCheckOutTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    var dynamicHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AddClassBloc(
        RepositoryProvider.of<AddClassRepository>(context),
      ),
      child: BlocBuilder<AddClassBloc, AddClassState>(
        builder: (context, state) {
          if (state.status == AddClassStatus.success) {
            return SafeArea(
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _onSuccess(dynamicHeight),
                ),
              ),
            );
          } else {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Add Class",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        if (state.status == AddClassStatus.failure)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.redAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (state.status == AddClassStatus.success)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        Text(
                          "Class Name",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextField(
                          onChanged: ((value) {
                            context
                                .read<AddClassBloc>()
                                .add(ClassNameChangedEvent(name: value));
                          }),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Check In Time",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _selectCheckInTime(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          _selectedCheckInTime.format(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Check Out Time",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _selectCheckOutTime(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          _selectedCheckOutTime.format(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Days of the week",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          height: 64,
                          child: MultiSelectDropdown.simpleList(
                            listTextStyle: const TextStyle(color: Colors.black),
                            list: const [
                              'Sunday',
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday',
                            ],
                            initiallySelected: const [],
                            onChange: (newList) {
                              context
                                  .read<AddClassBloc>()
                                  .add(DaysChangedEvent(days: newList));
                            },
                            numberOfItemsLabelToShow: 4,
                            isLarge: false, // Modal size will be a little large
                            boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white),
                              // color: Colors.white
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              (state.status == AddClassStatus.loading)
                                  ? null
                                  : context
                                      .read<AddClassBloc>()
                                      .add(AddClassButtonPressedEvent()),
                          icon: (state.status == AddClassStatus.loading)
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3,
                                )
                              : const Icon(Icons.feedback,
                                  color: Colors.transparent),
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: (state.status == AddClassStatus.loading)
                                ? const Text(
                                    "Adding class, Please wait...",
                                    textAlign: TextAlign.center,
                                  )
                                : const Text(
                                    "Add Class",
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _onSuccess(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.8,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.gpp_good_outlined,
              size: 256,
              color: Colors.white,
            ),
            const Text(
              "Class Added Successfully!",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DashBoard()),
                );
              },
              child: const Text(
                "Back to Dashboard",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
