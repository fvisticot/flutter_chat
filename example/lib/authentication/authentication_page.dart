import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  AuthenticationBloc _authBloc;


  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign In'),
      ),
      body:  Container(
          child: Center(
              child: RaisedButton(
                onPressed: () => _authBloc.dispatch(LogIn()),
                child: Text('Sign In With Google'),
              )
          )
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
