import 'package:chat_app/widget/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(
    String email,
    String name,
    String pass,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': name,
          'email': email,
        });
      }
    } on PlatformException catch (error) {
      var msg = 'an Error Occurred Please your credentials';

      if (error.message != null) {
        msg = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } //Platfrom exception throw errors that are send by the fireBase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
