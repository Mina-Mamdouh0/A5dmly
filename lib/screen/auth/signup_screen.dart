
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final genderList = ["Male","Female"];
  String? gender;
  final typeAccountList = ["User","Technical",'Winch owner'];
  String? typeAccount;
  final technicalList = ["Electrician","Mechanical technician",'Air conditioning refrigeration'];
  String? technical;
  final countryList = ["Cairo","Giza",'Alexandria'];
  String? country;

  bool passwordIsVisible = true;
  bool passwordConfirmIsVisible = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
         return Scaffold(
           appBar: AppBar(
             backgroundColor: Colors.orange,
             centerTitle: true,
             title: const Text(
               "Sign Up",
               style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
             ),
           ),
           body: Padding(
             padding: const EdgeInsets.all(20.0),
             child: SingleChildScrollView(
               child: Form(
                 key: formKey,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const SizedBox(height: 15.0),
                     TextFormField(
                       controller: nameController,
                       keyboardType: TextInputType.text,
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'must not be empty';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                         labelText: ("User Name"),
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
                         prefixIcon: const Icon(Icons.person,
                             color: Colors.orange),
                         errorBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(30),
                             borderSide: const BorderSide(color: Colors.red)
                         ),
                       ),
                     ),
                     const SizedBox(height: 15.0),
                     TextFormField(
                       controller: fullNameController,
                       keyboardType: TextInputType.text,
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'must not be empty';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                         labelText: ("Full Name"),
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
                         prefixIcon: const Icon(Icons.person,
                             color: Colors.orange),
                         errorBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(30),
                             borderSide: const BorderSide(color: Colors.red)
                         ),
                       ),
                     ),
                     const SizedBox(height: 15.0),
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
                         labelText: ("Email"),
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
                         prefixIcon: const Icon(Icons.email,
                             color: Colors.orange),
                         errorBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(30),
                             borderSide: const BorderSide(color: Colors.red)
                         ),
                       ),
                     ),
                     const SizedBox(height: 15.0),
                     TextFormField(
                       controller: passwordController,
                       keyboardType: TextInputType.text,
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'must not be empty';
                         }
                         return null;
                       },
                       obscureText: passwordIsVisible,
                       decoration: InputDecoration(
                         labelText: ("Password"),
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
                         prefixIcon: const Icon(Icons.lock_outlined,color: Colors.orange),
                         suffixIcon: IconButton(
                           icon: Icon(!passwordIsVisible
                               ? Icons.visibility_off_outlined
                               : Icons.remove_red_eye,color: Colors.orange),
                           onPressed: (() {
                             setState(() {
                               passwordIsVisible = !passwordIsVisible;
                             });
                           }),
                         ),
                       ),
                     ),
                     const SizedBox(height: 15.0),
                     TextFormField(
                       controller: confirmPasswordController,
                       keyboardType: TextInputType.text,
                       obscureText: passwordConfirmIsVisible,
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'must not be empty';
                         }
                         return null;
                       },
                       decoration: InputDecoration(
                         labelText: ("Confirm Password"),
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
                         prefixIcon: const Icon(Icons.lock_outlined,color: Colors.orange),
                         suffixIcon: IconButton(
                           icon: Icon(!passwordConfirmIsVisible
                               ? Icons.visibility_off_outlined
                               : Icons.remove_red_eye,color: Colors.orange),
                           onPressed: (() {
                             setState(() {
                               passwordConfirmIsVisible = !passwordConfirmIsVisible;
                             });
                           }),
                         ),
                       ),
                     ),
                     const SizedBox(height: 15.0),
                     TextFormField(
                       controller: phoneController,
                       keyboardType: TextInputType.number,
                       validator: (String? value) {
                         if (value!.isEmpty && value.length!=11) {
                           return 'must not be empty or not Correct';
                         }
                         return null;
                       },
                       inputFormatters:<TextInputFormatter>[
                         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                         FilteringTextInputFormatter.digitsOnly
                       ],
                       decoration: InputDecoration(
                         labelText: ("Phone"),
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
                         prefixIcon: const Icon(Icons.phone,color: Colors.orange),
                       ),
                     ),
                     const SizedBox(height: 15.0),
                     TextFormField(
                       controller: dateController,
                       keyboardType: TextInputType.text,
                       readOnly: true,
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'must not be empty';
                         }
                         return null;
                       },
                       onTap: (){
                         showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime(1990),
                             lastDate: DateTime.now()
                         ).then((value) {
                           if(value!=null){
                             dateController.text='${value.year}-${value.month}-${value.day}';
                           }
                         });
                       },
                       decoration: InputDecoration(
                         labelText: ("B-Date"),
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
                         prefixIcon: const Icon(Icons.calendar_today,color: Colors.orange),
                       ),
                     ),
                     const SizedBox(height: 15.0),
                     DropdownButtonFormField(
                       items:[...countryList.map((e) =>
                           DropdownMenuItem(
                             value: e,
                             child: Text(e),
                           ),)],
                       value: country,
                       onChanged: (value) {
                         setState(() {
                           country=value;
                         });
                       },
                       decoration: InputDecoration(
                         labelText: ("Country"),
                         labelStyle: const TextStyle(
                           color: Colors.orange,
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
                         prefixIcon: const Icon(Icons.merge_type,color: Colors.orange),
                       ),
                       validator: (value) {
                         if (value == null) {
                           return 'Please select your gender';
                         }
                         return null;
                       },),
                     const SizedBox(height: 15.0),
                     DropdownButtonFormField(
                       items:[...typeAccountList.map((e) =>
                           DropdownMenuItem(
                             value: e,
                             child: Text(e),
                           ),)],
                       value: typeAccount,
                       onChanged: (value) {
                         setState(() {
                           typeAccount=value;
                         });
                       },
                       decoration: InputDecoration(
                         labelText: ("TypeAccount"),
                         labelStyle: const TextStyle(
                           color: Colors.orange,
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
                         prefixIcon: const Icon(Icons.merge_type,color: Colors.orange),
                       ),
                       validator: (value) {
                         if (value == null) {
                           return 'Please select your gender';
                         }
                         return null;
                       },),
                     const SizedBox(height: 15.0),
                     typeAccount!='Technical'?Container():
                     DropdownButtonFormField(
                       items:[...technicalList.map((e) =>
                           DropdownMenuItem(
                             value: e,
                             child: Text(e),
                           ),)],
                       value: technical,
                       onChanged: (value) {
                         setState(() {
                           technical=value;
                         });
                       },
                       decoration: InputDecoration(
                         labelText: ("Technical"),
                         labelStyle: const TextStyle(
                           color: Colors.orange,
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
                         prefixIcon: const Icon(Icons.architecture_outlined,color: Colors.orange),
                       ),
                       validator: (value) {
                         if (value == null) {
                           return 'Please select your gender';
                         }
                         return null;
                       },  ),
                     const SizedBox(height: 15.0),
                     typeAccount!='User'?Container():
                     DropdownButtonFormField(
                       items:[...genderList.map((e) =>
                           DropdownMenuItem(
                             value: e,
                             child: Text(e),
                           ),)],
                       value: gender,
                       onChanged: (value) {
                         setState(() {
                           gender=value;
                         });
                       },
                       decoration: InputDecoration(
                         labelText: ("Select Gender"),
                         labelStyle: const TextStyle(
                           color: Colors.orange,
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
                         prefixIcon: const Icon(Icons.male,color: Colors.orange),
                       ),
                       validator: (value) {
                         if (value == null) {
                           return 'Please select your gender';
                         }
                         return null;
                       },  ),
                     const SizedBox(height: 15,),
                     (state is LoadingSignUpScreen)?
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
                           if (formKey.currentState!.validate()&&typeAccount!=null
                            && country!=null) {
                             if(passwordController.text.trim()==confirmPasswordController.text.trim()){
                               if(typeAccount=='User'&&gender!=null){
                                 cubit.userSignUp(
                                     email: emailController.text.trim(),
                                     password: passwordController.text.trim(),
                                     name: nameController.text.trim(),
                                     typeAccount: typeAccount!,
                                     country: country!,
                                     date: dateController.text.trim(),
                                     fullName: fullNameController.text.trim(),
                                     genderUser: gender!,
                                     phone: phoneController.text.trim(),
                                     technical:'Account User');
                               }
                               else if (typeAccount=='Technical'&&technical!=null){
                                 cubit.userSignUp(
                                     email: emailController.text.trim(),
                                     password: passwordController.text.trim(),
                                     name: nameController.text.trim(),
                                     typeAccount: typeAccount!,
                                     country: country!,
                                     date: dateController.text.trim(),
                                     fullName: fullNameController.text.trim(),
                                     genderUser: gender??'Account Not User',
                                     phone: phoneController.text.trim(),
                                     technical: technical!);
                               }
                               else if (typeAccount=='Winch owner'){
                                 cubit.userSignUp(
                                     email: emailController.text.trim(),
                                     password: passwordController.text.trim(),
                                     name: nameController.text.trim(),
                                     typeAccount: typeAccount!,
                                     country: country!,
                                     date: dateController.text.trim(),
                                     fullName: fullNameController.text.trim(),
                                     genderUser: gender??'Account Not User',
                                     phone: phoneController.text.trim(),
                                     technical: typeAccount!);
                               }
                               else{
                                 Fluttertoast.showToast(msg: 'Check Data');
                               }
                             }else{
                               Fluttertoast.showToast(msg: 'Password Not Confirmed');
                             }
                           }else{
                             Fluttertoast.showToast(msg: 'Check Data');
                           }
                         },
                         child:const Text(
                           "Register Now",
                           style: TextStyle(
                               color: Colors.white,
                               fontSize: 23,
                               fontWeight: FontWeight.bold),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         );
        },
        listener: (context, state){
          if(state is SuccessSignUpScreen){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
          }else if(state is ErrorSignUpScreen){
            Fluttertoast.showToast(msg: 'Check in Data');
          }
        });
  }
}

   