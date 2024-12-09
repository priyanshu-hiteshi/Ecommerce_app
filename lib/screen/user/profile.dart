import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Optional: for system messages on account deletion
import 'package:flutter/widgets.dart'; // Optional: for system messages on account deletion
import 'package:flutter/material.dart';
import '../auth/login.dart'; // Navigate to Login screen after logout

class Profile extends StatelessWidget {
  const Profile({super.key});

  // Function to log out and remove the token from SharedPreferences
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token
    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  // Function to delete the user account (simulated here by clearing token)
  Future<void> _deleteAccount(BuildContext context) async {
    // Show a confirmation dialog for account deletion
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancel deletion
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Simulate account deletion
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token'); // Remove the token
              Navigator.pop(context, true); // Confirm deletion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    // If the user confirmed the account deletion, navigate to login
    if (result == true) {
      // Additional logic for account deletion (e.g., call to an API)
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")));
    }
  }

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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context), // Log out functionality
              child: const Text('Logout'),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Colors.red)),
            //   onPressed: () =>
            //       _deleteAccount(context), // Delete account functionality
            //   child: const Text('Delete Account',
            //       style: TextStyle(color: Colors.white)),
            // ),
          ],
        ),
      ),
    );
  }
}
