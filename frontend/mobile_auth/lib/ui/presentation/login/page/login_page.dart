import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_auth/ui/presentation/home/page/home_page.dart';
import 'package:mobile_auth/ui/presentation/login/cubit/login_cubit.dart';
import 'package:mobile_auth/ui/util/extensions.dart';
import 'package:mobile_auth/ui/widgets/general_button.dart';
import 'package:mobile_auth/ui/widgets/general_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cubit = LoginCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: context.width,
          height: context.height,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocProvider<LoginCubit>(
            create: (context) {
              return cubit;
            },
            child: BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {

                if (state is LoginInProgressState) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          key: cubit.alertKey,
                          content: const SizedBox(
                              width: 50,
                              height: 50,
                              child:
                                  Center(child: CircularProgressIndicator())),
                        );
                      });
                }

                if (state is LoginSuccessState) {
                  context.pop;
                  context.pushReplacement(const HomePage());
                }
                if (state is LoginFailureState) {
                  if (cubit.alertKey.currentContext != null && (ModalRoute.of(cubit.alertKey.currentContext!)?.isCurrent ?? false)) {
                    context.pop;
                  }

                  Fluttertoast.showToast(
                      msg: state.msg,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: context.height * .1),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                    ),
                    const Text(
                      'Welcome to your login auth page',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: context.height * .1),
                    GeneralTextField(controller: cubit.email, label: 'Email',),
                    SizedBox(height: context.height * .01),
                    GeneralTextField(controller: cubit.password, label: 'Password', isPasswordField: true,),
                    SizedBox(height: context.height * .02),
                    GeneralButton(
                      onClick: () {
                        cubit.signInWithEmail(
                            cubit.email.text, cubit.password.text);
                      },
                      color: Colors.indigoAccent,
                      child: const Text(
                        'Log in app',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: context.height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: context.width * .3,
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        const Text(
                          'OR',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          width: context.width * .3,
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: context.height * .02),
                    GeneralButton(
                      onClick: () {
                        cubit.signInWithGoogle();
                      },
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            color: Colors.white,
                            height: 40,
                          ),
                          const Text(
                            'Sign in with Google ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
