import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Define the data to be uploaded
    Map<String, dynamic> data = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    };
    final String? userid = FirebaseAuth.instance.currentUser?.uid;
    // Upload the data as a new document with ID 'john-doe'

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unameController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      _isEmailValid = EmailValidator.validate(email);
    });
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _unameController.text.trim();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(username);
      firestore.doc('gesture_options/$userid').set(data)
            .then((value) => print('Data uploaded successfully!'))
            .catchError((error) => print('Failed to upload data: $error'));
            
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        // Initialize Firebase


    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
      'assets/logo2.png', // Replace with the actual path to your logo image
      width: 100, // Set the desired width
      height: 100,
      fit:BoxFit.contain, // Set the desired height
      // You can also use other properties like `fit`, `alignment`, etc. to customize the image
    ),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                errorText: _isEmailValid ? null : 'Please enter a valid email',
              ),
              onChanged: (value) {
                final email = value.trim();
                setState(() {
                  _isEmailValid = EmailValidator.validate(email);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _unameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your Username',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed:_isEmailValid ? _register : null,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Register'),
            ),
            SizedBox(height: 40.0),
            GestureDetector(
      onTap: () {
            
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: MouseRegion(
        cursor:SystemMouseCursors.click,
        child: Text(
          'Log in?',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    )
          ],
        ),
      ),
    );
  }
}
