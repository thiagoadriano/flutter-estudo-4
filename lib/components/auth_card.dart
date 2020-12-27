import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth_provider.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passController = TextEditingController();
  bool _isLoading = false;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _controller,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -10),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _controller,
      ),
    );
  }

  _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Ops!! Ocorreu um erro!'),
              content: Text(msg),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fechar'))
              ],
            ));
  }

  void _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    AuthProvider auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(_authData['email'], _authData['password']);
      } else {
        await auth.signup(_authData['email'], _authData['password']);
        _form.currentState.reset();
        _switchMode();
      }
    } on AuthException catch (error) {
      _showDialog(error.toString());
    } catch (error) {
      _showDialog('Ocorreu um erro inesperado');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchMode() {
    setState(() {
      if (_authMode == AuthMode.Signup) {
        _authMode = AuthMode.Login;
        _controller.reverse();
      } else {
        _controller.forward();
        _authMode = AuthMode.Signup;
      }
    });
  }

  Widget _btnSubmit() {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else {
      return RaisedButton.icon(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: _submit,
        icon: Icon(
            _authMode == AuthMode.Signup ? Icons.account_box : Icons.login),
        label: Text(
          _authMode == AuthMode.Signup ? 'Criar Conta' : 'Entrar',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.Signup ? 389 : 308,
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Informe um email valido';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.visiblePassword,
                controller: _passController,
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo e obrigatorio';
                  }
                  if (value.length < 5) {
                    return 'Esta senha nao e valida';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (_authMode == AuthMode.Login) return null;
                        
                        if (value.isEmpty) {
                          return 'Este campo e obrigatorio';
                        }
                        if (value != _passController.text) {
                          return 'As senhas sao diferentes';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Spacer(),
              _btnSubmit(),
              FlatButton(
                  onPressed: _switchMode,
                  child: Text(
                    _authMode == AuthMode.Signup ? 'Logar' : 'Registrar',
                  ),
                  textColor: Colors.blue.shade500)
            ],
          ),
        ),
      ),
    );
  }
}
