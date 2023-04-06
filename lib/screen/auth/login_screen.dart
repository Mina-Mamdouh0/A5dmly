
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/screen/auth/signup_screen.dart';
import 'package:a5dmny/screen/layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _passwordIsVisible = true;

  final formKey = GlobalKey<FormState>();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/images/logo.png"),
                          ),
                        ),
                        const Center(
                          child: Text(
                            "A5dmny",
                            style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "login now to use our services:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'must not be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: ("Email Address"),
                            labelStyle: const TextStyle(
                                color: Colors.orange
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.orange)
                            ),
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.orange),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.red)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'must not be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: ('PassWord'),
                              labelStyle: const TextStyle(
                                  color: Colors.orange
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.orange)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.red)
                              ),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Colors.orange),
                              suffixIcon: IconButton(
                                icon: Icon(!_passwordIsVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.remove_red_eye,color: Colors.orange),
                                onPressed: () {
                                  setState(() {
                                    _passwordIsVisible = !_passwordIsVisible;
                                  });
                                },
                              )),

                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        (state is LoadingLoginScreen)?
                        const Center(child: CircularProgressIndicator(color: Colors.orange),):
                        Center(
                          child: MaterialButton(
                            color: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());
                              }else{
                                Fluttertoast.showToast(msg: 'check Data');
                              }
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Register Now",
                                  style: TextStyle(color: Colors.orange),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state)async{
          if(state is SuccessLoginScreen){
            BlocProvider.of<AppCubit>(context).getDateUser();
            requestPermission();
          }
          if(state is SuccessGetDataUser){

            if(BlocProvider.of<AppCubit>(context).userModel!.typeAccount=='User'){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LayoutScreen(isUser: true,)));
              BlocProvider.of<AppCubit>(context).getDateOrdersUsers();
              BlocProvider.of<AppCubit>(context).getDateOrdersFinishUsers();
              BlocProvider.of<AppCubit>(context).getNotification();
              await FirebaseMessaging.instance.getToken().then(
                      (token)async {
                    await FirebaseFirestore.instance.collection("UserTokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      'token' : token,
                    });
                  }
              );
            }else{
              BlocProvider.of<AppCubit>(context).getDateOrdersTechnical();
              BlocProvider.of<AppCubit>(context).getDateOrdersConfirmTechnical();
              BlocProvider.of<AppCubit>(context).getDateOrdersFinishTechnical();
              await FirebaseMessaging.instance.getToken().then(
                      (token)async {
                    await FirebaseFirestore.instance.collection("UserTokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      'token' : token,
                    });
                  }
              );
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LayoutScreen(isUser: false,)));
              //BlocProvider.of<AppCubit>(context).getOrdersAdmin();
            }
          }
          if(state is ErrorLoginScreen){
            Fluttertoast.showToast(msg: 'Check Data');
          }
        });
  }
}
