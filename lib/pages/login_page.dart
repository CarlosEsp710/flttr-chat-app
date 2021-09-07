// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/helpers/show_alert.dart';

import 'package:chat/services/auth_service.dart';

import 'package:chat/widgets/logo.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/btn_blue.dart';
import 'package:chat/widgets/labels.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  route: 'register',
                  title: '¿No tienes una cuenta?',
                  subtitle: 'Regístrate!',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.security_outlined,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            isPassword: true,
            textController: passwordCtrl,
          ),
          BlueButton(
            text: 'Iniciar Sesión',
            onPressed: authService.authenticating
                ? () => {}
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginStatus = await authService.login(
                        emailCtrl.text.trim(), passwordCtrl.text.trim());

                    if (loginStatus) {
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(context, 'Login incorrecto',
                          'Revise sus credenciales nuvamente');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
