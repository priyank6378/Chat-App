import 'package:chat_app/service/crud/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/const/route.dart';
import 'package:chat_app/service/auth_providers.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key, User? user});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  User? user = GoogleAuthentication().getUser();
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    _firestoreService.addUser(
      user?.email ?? "",
      user?.displayName ?? "UNKNOWN",
      user?.uid ?? "",
      user?.photoURL ??
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
    );

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 230, 234, 231),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          user!.photoURL ??
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.displayName ?? "UNKNOWN",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(profileRoute);
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              ListTile(
                onTap: () {
                  FirebaseAuthProvider().logOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginPageRoute, (route) => false);
                },
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Chat App"),
          centerTitle: true,
        ),
        body: Center(
          child: allUsersWidget(),
        ));
  }

  Widget allUsersWidget() {
    return StreamBuilder(
      stream: _firestoreService.allUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allUsers = snapshot.data;
          return ListView.builder(
            itemCount: allUsers?.docs.length,
            itemBuilder: (context, index) {
              final otherUser = allUsers?.docs[index];
              if (otherUser!['email'] == user?.email) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(chatPageRoute, arguments: {
                    'otherUser': otherUser,
                    'user': user,
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: const BoxDecoration(
                      // color: Color.fromARGB(255, 243, 239, 239),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: NetworkImage(otherUser['photoUrl']),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            otherUser['userName'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            otherUser['email'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
