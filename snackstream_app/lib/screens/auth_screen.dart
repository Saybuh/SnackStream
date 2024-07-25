import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'driver_home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  String _role = 'customer';

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _handleAuth(AuthService authService) async {
    if (_isLogin) {
      final user = await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        _showToast('Login successful');
        if (authService.userRole == 'driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DriverHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        _showToast('Login failed');
      }
    } else {
      final user = await authService.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _role,
      );
      if (user != null) {
        _showToast('Account created');
        setState(() {
          _isLogin = true;
        });
      } else {
        _showToast('Registration failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (!_isLogin)
              Row(
                children: [
                  Radio(
                    value: 'customer',
                    groupValue: _role,
                    onChanged: (value) {
                      setState(() {
                        _role = value.toString();
                      });
                    },
                  ),
                  Text('Customer'),
                  Radio(
                    value: 'driver',
                    groupValue: _role,
                    onChanged: (value) {
                      setState(() {
                        _role = value.toString();
                      });
                    },
                  ),
                  Text('Driver'),
                ],
              ),
            ElevatedButton(
              onPressed: () => _handleAuth(authService),
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                  _isLogin ? 'Create an account' : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}
