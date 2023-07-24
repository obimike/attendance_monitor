import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackMessage extends StatefulWidget {
  const FeedbackMessage({super.key});

  @override
  State<FeedbackMessage> createState() => _FeedbackMessageState();
}

class _FeedbackMessageState extends State<FeedbackMessage> {
  final TextEditingController _messageController = TextEditingController();
  String get _message => _messageController.text;

  bool isLoading = false;
  String error = '';
  String success = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Send Feedback",
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
                  const SizedBox(
                    height: 24,
                  ),
                  if (error.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          error,
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
                  if (success.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          success,
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
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Message",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextField(
                    controller: _messageController,
                    maxLines: 6,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      isLoading == true ? null : handleSendMessage();
                    },
                    icon: isLoading == true
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                          )
                        : const Icon(Icons.feedback, color: Colors.transparent),
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: isLoading == true
                          ? const Text(
                              "Submitting feedback, Please wait...",
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              "Submit Feedback",
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

  void handleSendMessage() async {
    if (_message.isNotEmpty) {
      setState(() {
        isLoading = true;
        error = '';
        success = '';
      });

      try {
        final user = FirebaseAuth.instance.currentUser;

        final userData = <String, dynamic>{
          "Massage": _message,
          "email": user?.email,
          "name": user?.displayName
        };

        await FirebaseFirestore.instance.collection("feedback").add(userData).then((value) =>
            setState(() {
              isLoading = false;
              success = 'Message successfully sent.';
              _messageController.text = '';
            }),
        );

      } on Exception catch (e) {
        setState(() {
          isLoading = false;
          error = e.toString();
        });
      }
    } else {
      setState(() {
        isLoading = false;
        error = 'Message cannot be empty!';
      });
    }
  }
}
