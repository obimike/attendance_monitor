import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String get _confirmPassword => _confirmPasswordController.text;
  String get _newPassword => _newPasswordController.text;


  bool _obscureText = true;
  bool isLoading = false;
  String error = '';
  String success = '';

  void handlePasswordChange() {
    if (_confirmPassword.isNotEmpty && _newPassword.isNotEmpty) {
      setState(() {
        isLoading = true;
        error = '';
        success = '';
      });
      if (_confirmPassword == _newPassword) {
        try {
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user != null) {
              user.updatePassword(_newPassword).then((value) {
                setState(() {
                  isLoading = false;
                  success = 'Password change was successful.';
                  _confirmPasswordController.text = '';
                  _newPasswordController.text = '';
                });
              }).catchError((e) {
                setState(() {
                  isLoading = false;
                  error = e.toString();
                });
              });
            }
          });
        } on Exception catch (e) {
          setState(() {
            isLoading = false;
            error = e.toString();
          });
        }
      } else {
        setState(() {
          isLoading = false;
          error = 'Password do not match!';
        });
      }
    } else {
      setState(() {
        isLoading = false;
        error = 'All fields are required!';
      });
    }

    print(isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 48,
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
              height: 16,
            ),
            Text(
              "New Password",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Confirm Password",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: () {
                // handlePasswordChange();
                isLoading == true ? null : handlePasswordChange();
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
                        "Submitting changes, Please wait...",
                        textAlign: TextAlign.center,
                      )
                    : const Text(
                        "Submit Changes",
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
