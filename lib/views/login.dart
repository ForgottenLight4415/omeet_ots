import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/blocs/auth_bloc/auth_cubit.dart';
import 'package:rc_clone/utilities/check_connection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rc_clone/widgets/input_fields.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  Color _passBorderColor = Colors.transparent;
  Color _emailBorderColor = Colors.transparent;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _passFocusNode.addListener(() {
      setState(() {
        _passBorderColor =
            _passFocusNode.hasFocus ? Colors.deepOrange : Colors.transparent;
      });
    });

    _emailFocusNode.addListener(() {
      setState(() {
        _emailBorderColor =
            _emailFocusNode.hasFocus ? Colors.deepOrange : Colors.transparent;
      });
    });
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();

    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
              padding: MaterialStateProperty.resolveWith(
                (states) =>
                    EdgeInsets.symmetric(horizontal: 70.w, vertical: 16.h),
              ),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              elevation: MaterialStateProperty.resolveWith((states) => 5.0)),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Center(
              child: AnimatedCrossFade(
                crossFadeState: _crossFadeState,
                duration: const Duration(milliseconds: 500),
                firstChild: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 50.sp,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign in to continue",
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        textEditingController: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocusNode,
                        label: "Email address",
                        hintText: "Enter registered email address",
                        borderColor: _emailBorderColor,
                        validator: _isEmailValid,
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        textEditingController: _passwordController,
                        textInputAction: TextInputAction.done,
                        focusNode: _passFocusNode,
                        label: "Password",
                        hintText: "Enter your password",
                        borderColor: _passBorderColor,
                        validator: _isPasswordValid,
                        obscureText: true,
                      ),
                      SizedBox(height: 28.h),
                      BlocProvider<AuthCubit>(
                        create: (context) => AuthCubit(),
                        child: BlocConsumer<AuthCubit, AuthState>(
                          listener: _authListener,
                          builder: (context, state) => ElevatedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState!.validate()) {
                                if (await checkConnection(context)) {
                                  BlocProvider.of<AuthCubit>(context).signIn(
                                    _emailController!.text,
                                    _passwordController!.text,
                                  );
                                } else {
                                  return;
                                }
                              }
                            },
                            child: const Text("SIGN IN"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                secondChild: const Center(child: CircularProgressIndicator()),
                layoutBuilder:
                    (topChild, topChildKey, bottomChild, bottomChildKey) {
                  return Stack(
                    clipBehavior: Clip.none,
                    // Align the non-positioned child to center.
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        key: bottomChildKey,
                        top: 0,
                        bottom: 0,
                        child: bottomChild,
                      ),
                      Positioned(
                        key: topChildKey,
                        child: topChild,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _isEmailValid(String? email) {
    String _pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp _regex = RegExp(_pattern);
    if (_regex.hasMatch(email!)) {
      return null;
    }
    return "Invalid email address";
  }

  String? _isPasswordValid(String? password) {
    if (password!.isNotEmpty) {
      return null;
    }
    return "Password cannot be empty";
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (state is AuthFailed) {
      setState(() {
        _crossFadeState = CrossFadeState.showFirst;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign in failed. (${state.cause})"),
      ));
    } else {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    }
  }
}
