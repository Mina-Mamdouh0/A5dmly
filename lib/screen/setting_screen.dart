
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/screen/edit_profile_screen.dart';
import 'package:a5dmny/screen/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
         return Scaffold(
             body: SingleChildScrollView(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const SizedBox(
                       height: 15,
                     ),
                     RichText(
                       text: TextSpan(
                         text: 'Hi,  ',
                         style: const TextStyle(
                           color: Colors.orange,
                           fontSize: 27,
                           fontWeight: FontWeight.bold,
                         ),
                         children: <TextSpan>[
                           TextSpan(
                               text: cubit.userModel!=null?cubit.userModel!.name:'Name',
                               style: const TextStyle(
                                 fontSize: 25,
                                 fontWeight: FontWeight.w600,
                               ),),
                         ],
                       ),
                     ),
                     const SizedBox(
                       height: 5,
                     ),
                     TextWidget(
                       text: cubit.userModel!=null?cubit.userModel!.email:'exmaple@gmail.com',
                       textSize: 18,
                       // isTitle: true,
                     ),
                     const SizedBox(
                       height: 20,
                     ),
                     const Divider(
                       thickness: 2,
                     ),
                     const SizedBox(
                       height: 20,
                     ),
                     _listTiles(
                       title: 'Edit Profile',
                       icon: Icons.edit,
                       onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen()));
                       },
                     ),
                     _listTiles(
                       title: 'Help',
                       icon: Icons.help_rounded,
                       onPressed: () {},
                     ),
                     _listTiles(
                       title: 'About',
                       icon: Icons.help_center_rounded,
                       onPressed: () {
                       },
                     ),
                     _listTiles(
                       title: 'Rating App',
                       icon: Icons.star,
                       onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const RatingScreen()));
                       },
                     ),
                     SwitchListTile(
                       title: TextWidget(
                         text:  'Light mode',
                         textSize: 20,
                         // isTitle: true,
                       ),
                       secondary: const Icon(Icons.light_mode_outlined),
                       onChanged: (bool value) {

                       },
                       value: true,
                     ),
                     _listTiles(
                       title:  'Logout',
                       icon:  Icons.logout,
                       onPressed: () {
                         showDialog(
                             context: context,
                             builder: (BuildContext ctx) {
                               return AlertDialog(
                                 title: Row(
                                   children: const[
                                     Padding(
                                       padding:
                                        EdgeInsets.only(right: 6.0),
                                       child: Icon(Icons.logout),
                                     ),
                                      Padding(
                                       padding:  EdgeInsets.all(8.0),
                                       child: Text('Sign out'),
                                     ),
                                   ],
                                 ),
                                 content: const Text('Do you wanna Sign out?'),
                                 actions: [
                                   TextButton(
                                       onPressed: () async {
                                         Navigator.pop(context);
                                       },
                                       child: const Text('Cancel')),
                                   TextButton(
                                       onPressed: (){
                                         cubit.signOut();
                                       },
                                       child: const Text(
                                         'Ok',
                                         style: TextStyle(color: Colors.red),
                                       ))
                                 ],
                               );
                             });
                       },
                     ),
                     // listTileAsRow(),
                   ],
                 ),
               ),
             ));
        },
        listener: (context, state){});
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        textSize: 20,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        onPressed();
      },
    );
  }
}

class TextWidget extends StatelessWidget {
  TextWidget({
    Key? key,
    required this.text,
    required this.textSize,
    this.isTitle = false,
    this.maxLines = 10,
  }) : super(key: key);
  final String text;
  final double textSize;
  bool isTitle;
  int maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: textSize,
          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal),
    );
  }
}

