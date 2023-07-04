import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});



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
                      "Privacy Policy",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "At Attendify, we are committed to protecting the privacy of our users. This Privacy Policy outlines how we collect, use, and disclose personal information when you use our Attendance Monitor app. "
                        "Please read this policy carefully to understand our practices regarding your personal information. \n"
                        "\nInformation We Collect:\n\n 1.1 Personal Information:   When you use our Attendance Monitor app, we may collect personal information such as your name, email address, student ID, and geolocation data. \n "
                        "\n1.2 Geolocation Data: Our app uses geolocation technology to track and record students' attendance. We collect and process location data to determine student presence within the institution's premises. "
                        "Use of Collected Information:\n\n 2.1 Personal Information: We use the personal information collected to: Identify students and match attendance records with student profiles. Communicate with students "
                        "regarding their attendance and related updates. Provide support and resolve any issues or concerns. Improve our app and services.\n\n 2.2 Geolocation Data: We use geolocation data solely for the purpose "
                        "of tracking and recording students' attendance within the institution's premises. This data helps us ensure accurate attendance records. Data Retention: \n\n 3.1 Personal Information: We retain personal "
                        "information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law. \n\n 3.2 Geolocation Data: Geolocation data"
                        " is retained only for the duration necessary to record attendance. Once attendance records are processed, the specific geolocation data is no longer retained. \n\n 4.1 Data Security: We implement "
                        "appropriate technical and organizational measures to protect the personal information and geolocation data we collect and process. However, please note that no method of transmission or storage over"
                        " the Internet is completely secure, and we cannot guarantee the absolute security of your data. \n\n5.1 Data Disclosure: We do not sell, trade, or otherwise transfer personal information or geolocation"
                        " data to third parties, except as required by law, regulation, or if necessary to comply with a legal process.\n\n 6.1 Changes to this Privacy Policy:\n We may update this Privacy Policy from time to time."
                        " Any changes will be effective upon posting the revised policy on our app. We encourage you to review this Privacy Policy periodically for any updates. \n\n 7.1 Contact Us:\n If you have any questions or "
                        "concerns about this Privacy Policy or our data practices, please contact us at Attendify. By using our Attendance Monitor app, you consent to the collection, use, and disclosure of your "
                        "personal information and geolocation data as outlined in this Privacy Policy."
                  ,
                    style: Theme.of(context).textTheme.bodySmall,
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
