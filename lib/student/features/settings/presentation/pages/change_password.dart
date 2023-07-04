import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Back",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
        ),
        body: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Text(
                    "Current Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    // controller: _emailController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "New Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    // controller: _emailController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Confirm New Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    // controller: _emailController,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child:const Center(
                      child:  Text(
                        "Submit Change",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
