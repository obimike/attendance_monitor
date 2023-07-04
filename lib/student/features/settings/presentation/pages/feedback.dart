import 'package:flutter/material.dart';

class FeedbackMessage extends StatelessWidget {
  const FeedbackMessage({super.key});

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
                      "Send Feedback",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Text(
                    "Message",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const TextField(
                    // controller: _emailController,
                    maxLines: 6,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Center(
                      child: Text(
                        "Send",
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
