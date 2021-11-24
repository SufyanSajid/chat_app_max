import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String pass, bool islogin,
      BuildContext ctx) submitFn;
  final isloading;

  AuthForm(this.submitFn, this.isloading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPass = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context)
        .unfocus(); //it will close the keyboad after the form is submitted
    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPass.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text('Email Address'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please Enter a valid email Address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    decoration: InputDecoration(
                      label: Text('UserName'),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length <= 4) {
                        return 'UserName Must contain 4 character';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(
                    label: Text('Password'),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Must be 7 Characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPass = value!;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isloading) CircularProgressIndicator(),
                if (!widget.isloading)
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'SignUp'),
                  ),
                if (!widget.isloading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'Already Have an Account'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
