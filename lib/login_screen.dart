import 'package:flutter/material.dart';
import 'package:project/database_helper.dart';
import 'package:project/user.dart';
import 'package:project/admin_home.dart';
import 'package:project/home_screen.dart';
import 'package:project/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper.instance.database;
      final users = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [_usernameController.text, _passwordController.text],
      );

      if (users.isNotEmpty) {
        final user = User.fromMap(users.first);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => user.isAdmin
                ? AdminHomeScreen(user: user)
                : HomeScreen(user: user),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University Event Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Sign up"),
              ),
              ElevatedButton(
                onPressed: () {
                  _usernameController.text = 'admin';
                  _passwordController.text = 'admin123';
                },
                child: const Text('Admin Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
