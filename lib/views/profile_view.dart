import 'package:chat_app/const/route.dart';
import 'package:chat_app/const/styles/button_styles.dart';
import 'package:chat_app/service/auth_providers.dart';
import 'package:chat_app/service/crud/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _userNameController = TextEditingController();
  final user = FirebaseAuthProvider().currentUser();

  @override
  Widget build(BuildContext context) {
    _userNameController.text = user?.displayName ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: "User Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: customButtonStyle1,
                onPressed: () async {
                  await FirestoreService().updateUserName(
                    user?.uid ?? "",
                    _userNameController.text,
                  );
                  FirebaseAuthProvider()
                      .changeUserName(_userNameController.text);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homePageRoute, (route) => false);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  FirestoreService().deleteUser(user?.uid);
                  FirebaseAuthProvider().deleteUser();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      loginPageRoute, (route) => false);
                },
                style: customButtonStyle1,
                child: const Text(
                  "Delete Account !",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
