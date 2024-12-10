import 'package:ecommerce/main.dart';
import 'package:ecommerce/provider/bottom_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login.dart'; // Navigate to Login screen after logout
import '../../models/user.dart'; // Import the User model
import '../../services/all_product_api.dart'; // Service to fetch user data

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser =
        ProductService().fetchUser(); // Fetch user data when the screen loads
  }

  // Function to log out and remove the token from SharedPreferences
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token
    // Navigate back to the login screen
    context.read<BottomNavBarProvider>().updatedIndex(0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  // Function to delete the user account (simulated here by clearing token)
  // Future<void> _deleteAccount(BuildContext context) async {
  //   // Show a confirmation dialog for account deletion
  //   final result = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Delete Account"),
  //       content: const Text(
  //           "Are you sure you want to delete your account? This action cannot be undone."),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context, false); // Cancel deletion
  //           },
  //           child: const Text("Cancel"),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             // Simulate account deletion
  //             final prefs = await SharedPreferences.getInstance();
  //             await prefs.remove('token'); // Remove the token
  //             Navigator.pop(context, true); // Confirm deletion
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => const Login()),
  //             );
  //           },
  //           child: const Text("Delete"),
  //         ),
  //       ],
  //     ),
  //   );

  //   // If the user confirmed the account deletion, navigate to login
  //   if (result == true) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Account deleted successfully")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _logout(context), // Log out functionality
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
                // ElevatedButton.icon(
                //   style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all(Colors.red)),
                //   onPressed: () => _deleteAccount(context), // Delete account
                //   icon: const Icon(Icons.delete),
                //   label: const Text(
                //     'Delete Account',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${user.firstname} ${user.lastname}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Email: ${user.email}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        Text('Username: ${user.username}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        Text('Phone: ${user.phone}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(
                            'Address: ${user.street}, ${user.city}, ${user.zipcode}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                } else {
                  return const Text('No user data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
