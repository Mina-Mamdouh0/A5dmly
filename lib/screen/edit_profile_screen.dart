
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
   EditProfileScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
               "Edit Info",
               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
             ),
             leading: IconButton(
               onPressed: (){
                 Navigator.pop(context);
                 cubit.file=null;
               },
               icon: const Icon(Icons.arrow_back,color: Colors.white),
             ),
           ),
           body: SingleChildScrollView(
             padding: const EdgeInsets.all(10),
             child: Form(
               key: formKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   const SizedBox(height: 20,),
                   Stack(
                     alignment: Alignment.topRight,
                     children: [
                       Container(
                         margin:const  EdgeInsets.all(10),
                         height: MediaQuery.of(context).size.width*0.2,
                         width: MediaQuery.of(context).size.width*0.2,
                         decoration: BoxDecoration(
                           border: Border.all(
                             color: Colors.white,width: 1,
                           ),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: cubit.file==null?Image.asset('assets/images/logo.png',
                             fit: BoxFit.fill,):Image.file(cubit.file!,
                             fit: BoxFit.fill,),
                         ),
                       ),
                       GestureDetector(
                         onTap: (){
                           showDialog(context: context,
                               builder: (context){
                                 return AlertDialog(
                                   title:const  Text(
                                     'Choose Image',
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.black,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   content: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       InkWell(
                                         onTap: ()async{
                                           Navigator.pop(context);
                                           XFile? picked=await ImagePicker().pickImage(source: ImageSource.camera,maxHeight: 1080,maxWidth: 1080);
                                           if(picked !=null){
                                             cubit.changeImage(picked.path);
                                           }
                                         },
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                             children: const [
                                               Icon(Icons.photo,color: Colors.orange,),
                                               SizedBox(width: 10,),
                                               Text('Camera',
                                                 style: TextStyle(
                                                     color: Colors.orange,fontSize: 20
                                                 ),)
                                             ],
                                           ),
                                         ),
                                       ),
                                       InkWell(
                                         onTap: ()async{
                                           Navigator.pop(context);
                                           XFile? picked=await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 1080,maxWidth: 1080);
                                           if(picked !=null){
                                             cubit.changeImage(picked.path);
                                           }
                                         },
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                             children: const [
                                               Icon(Icons.camera,color: Colors.orange,),
                                               SizedBox(width: 10,),
                                               Text('Gallery',
                                                 style: TextStyle(
                                                     color: Colors.orange,fontSize: 20
                                                 ),)
                                             ],
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 );
                               });
                         },
                         child: Container(
                           height: 30,
                           width: 30,
                           decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               border: Border.all(width: 2,
                                   color: Colors.white),
                               color: Colors.pink
                           ),
                           child: Icon(cubit.file==null?Icons.camera_alt:Icons.edit,
                             color: Colors.white,
                             size: 20,),

                         ),
                       )
                     ],
                   ),
                   const SizedBox(height: 10,),
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
                       labelText: ("Edit Name"),
                       labelStyle: const TextStyle(
                           color: Colors.orange
                       ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.orange)
                       ),
                       prefixIcon: const Icon(Icons.drive_file_rename_outline,
                           color: Colors.orange),
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.red)
                       ),
                     ),
                   ),
                   const SizedBox(height: 10,),
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
                       labelText: ("Edit Full Name"),
                       labelStyle: const TextStyle(
                           color: Colors.orange
                       ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.orange)
                       ),
                       prefixIcon: const Icon(Icons.description,
                           color: Colors.orange),
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.red)
                       ),
                     ),
                   ),
                   const SizedBox(height: 10,),
                   TextFormField(
                     controller: phoneController,
                     keyboardType: TextInputType.number,
                     validator: (String? value) {
                       if (value!.isEmpty && value.length!=11) {
                         return 'must not be empty';
                       }
                       return null;
                     },
                     inputFormatters:<TextInputFormatter>[
                       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                       FilteringTextInputFormatter.digitsOnly
                     ],
                     decoration: InputDecoration(
                       labelText: ("Edit Phone"),
                       labelStyle: const TextStyle(
                           color: Colors.orange
                       ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.orange)
                       ),
                       prefixIcon: const Icon(Icons.money,
                           color: Colors.orange),
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.red)
                       ),
                     ),
                   ),
                   const SizedBox(height: 10,),
                   (state is LoadingEditInfo)?
                   const Center(child: CircularProgressIndicator(color: Colors.orange),)
                       :MaterialButton(
                     color: Colors.orange,
                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                     shape: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                       borderSide: BorderSide.none,
                     ),
                     onPressed: () {
                       if (formKey.currentState!.validate()) {
                         if(cubit.file!=null){
                           cubit.editInfo(
                               name: nameController.text,
                               fullName: fullNameController.text,
                               phone: phoneController.text);
                         }else{
                           Fluttertoast.showToast(msg: 'check to Chose image');
                         }
                       }else{
                         Fluttertoast.showToast(msg: 'check Data');
                       }
                     },
                     child: const Text(
                       "Edit Info",
                       style: TextStyle(
                           color: Colors.white,
                           fontSize: 23,
                           fontWeight: FontWeight.bold),
                     ),
                   ),

                 ],
               ),
             ),
           ),

         );
        },
        listener: (context, state){
          if(state is SuccessEditInfo){
            BlocProvider.of<AppCubit>(context).getDateUser();
            BlocProvider.of<AppCubit>(context).file=null;
            Navigator.of(context).pop();
          }else if(state is ErrorEditInfo){
            Fluttertoast.showToast(msg: 'Error in Edit');
            BlocProvider.of<AppCubit>(context).file=null;
            Navigator.of(context).pop();
          }
        });
  }
}
