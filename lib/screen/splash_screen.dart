
import 'dart:async';

import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/screen/auth/login_screen.dart';
import 'package:a5dmny/screen/layout_screen.dart';
import 'package:a5dmny/screen/onboarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            () async{
              if(FirebaseAuth.instance.currentUser==null){
                SharedPreferences preferences=await SharedPreferences.getInstance();
                preferences.getBool('isShow')??false ?
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()))
                    :Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>OnBoardingPage()));


              }
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit,AppStates>(
        listener: (context, state)async{
          if(state is SuccessGetDataUser){
            if(BlocProvider.of<AppCubit>(context).userModel!.typeAccount=='User'){
              BlocProvider.of<AppCubit>(context).getDateOrdersUsers();
              BlocProvider.of<AppCubit>(context).getNotification();
              BlocProvider.of<AppCubit>(context).getDateOrdersFinishUsers();
              await FirebaseMessaging.instance.getToken().then(
                      (token)async {
                    await FirebaseFirestore.instance.collection("UserTokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      'token' : token,
                    });
                  }
              );
              Timer(const Duration(seconds: 3),
                      () async{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LayoutScreen(isUser: true)));
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
              Timer(const Duration(seconds: 3),
                      () async{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LayoutScreen(isUser: false)));
                      }
              );
            }
          }

        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 150, 62),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/logo.png'),
              const SizedBox(height: 20,),
              const Text(
                "A5dmny",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const CircularProgressIndicator(color: Colors.white,),
              const SizedBox(height: 10,),
              const Text("Loading..."),
              const SizedBox(height: 20,),
            ],
          ),
        ),
        );
  }
}
