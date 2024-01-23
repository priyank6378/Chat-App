import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternetView extends StatelessWidget {
  final String directRoute;

  const NoInternetView({super.key, required this.directRoute});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InternetConnectionChecker().hasConnection,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            Navigator.of(context).pushReplacementNamed(directRoute);
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off),
                    const SizedBox(height: 10),
                    const Text("No Internet Connection"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        bool connection =
                            await InternetConnectionChecker().hasConnection;
                        if (connection == true)
                          Navigator.of(context)
                              .pushReplacementNamed(directRoute);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text("Please connect to internet!")));
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
