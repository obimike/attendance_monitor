import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
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
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Profile Information Settings",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            radius: 90,
                            backgroundImage: AssetImage('images/user.png'),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black,
                                child: IconButton(
                                    onPressed: () {},
                                    color: Colors.white,
                                    iconSize: 36,
                                    icon: Icon(Icons.photo_camera_outlined)),
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Container(
                    width: dynamicWidth,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Full Name",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "Natashia Khaleria",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Gender",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "Male",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Class ID:",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "qyv5yw2os67890ebu8",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Email ID",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "natashia_khaleria@gmail.com",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Date Of Birth",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          "22nd January, 1999",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),

                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
