
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/compont.dart';
import 'package:a5dmny/screen/chat_screen.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersUserScreen extends StatelessWidget {
  const  OrdersUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
         return  RefreshIndicator(
           onRefresh: ()async{
             cubit.getDateOrdersUsers();
         },
           child: cubit.ordersUserList.isEmpty?
           Center(child: emptyData(),):ListView.builder(
             itemCount: cubit.ordersUserList.length,
               padding: const EdgeInsets.all(10),
               itemBuilder: (context,index){
                 return Container(
                   padding: const EdgeInsets.all(10),
                   margin: const EdgeInsets.symmetric(vertical: 10),
                   decoration: BoxDecoration(
                      color: Colors.orange,
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                     Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       CircleAvatar(
                         backgroundImage: NetworkImage(cubit.ordersUserList[index].imageOrder,),
                         backgroundColor: Colors.white,
                         onBackgroundImageError:(Object, StackTrace){
                           const AssetImage('assets/images/logo.png',);
                         } ,
                         //foregroundImage: NetworkImage(urlImageSignUp),
                         maxRadius: 40,
                       ),
                       const SizedBox(width: 10,),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             Text(cubit.ordersUserList[index].name,
                             style: const TextStyle(
                               color: Colors.white,
                               fontSize: 20,
                               fontWeight: FontWeight.bold,
                             )),
                             Text(cubit.ordersUserList[index].typeTechnical,
                                 style: const TextStyle(
                                   color: Colors.white,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                           ],
                         ),
                       ),
                       IconButton(
                         onPressed: (){
                           showDialog(context: context,
                               barrierColor: Colors.black12,
                               barrierDismissible: false,
                               useSafeArea: true,
                               builder: (context)=>
                                   AlertDialog(
                                     title: const Text('QR Code'),
                                     elevation: 10.0,
                                     contentPadding: const EdgeInsets.all(5),
                                     titlePadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                                     actionsAlignment: MainAxisAlignment.center,
                                     alignment: Alignment.center,
                                     content: Container(
                                       color: Colors.white,
                                       child: BarcodeWidget(
                                         data:cubit.ordersUserList[index].idOrder,
                                         barcode: Barcode.qrCode(),
                                         color: Colors.black,
                                         height: 250,
                                         width: 250,
                                         backgroundColor: Colors.white,
                                         drawText: true,
                                         decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(10)
                                         ),
                                       ),
                                     ),
                                     actions: [
                                       TextButton(onPressed: (){
                                         Navigator.of(context).pop();
                               },
                               child: const Text('OK')),
                                     ],
                                   ));
                         },
                         icon: const Icon(Icons.qr_code_scanner,
                           color: Colors.white,
                           size: 40,),
                       )
                     ],
                   ),
                       const Divider(color: Colors.white, height: 10),
                       const SizedBox(height: 10,),
                       RichText(
                       text: TextSpan(
                           children: [
                             const TextSpan(text: 'TypeTechnical : ',
                                 style:  TextStyle(
                                   color: Colors.black,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 )),
                             TextSpan(text: cubit.ordersUserList[index].typeTechnical,
                               style: const TextStyle(
                                 overflow: TextOverflow.ellipsis,
                                 color: Colors.white,
                                 fontSize: 18,
                                 fontWeight: FontWeight.normal,
                               ),),
                           ]
                       )),
                       const SizedBox(height: 5,),
                       RichText(
                           text: TextSpan(
                               children: [
                                 const TextSpan(text: 'Location : ',
                                     style:  TextStyle(
                                       color: Colors.black,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                     )),
                                 TextSpan(text: cubit.ordersUserList[index].currentLocation,
                                   style: const TextStyle(
                                     overflow: TextOverflow.ellipsis,
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.normal,
                                   ),),
                               ]
                           )),
                       const SizedBox(height: 5,),
                       RichText(
                           text: TextSpan(
                               children: [
                                 const TextSpan(text: 'Technical ID: ',
                                     style:  TextStyle(
                                       color: Colors.black,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                     )),
                                 TextSpan(text: cubit.ordersUserList[index].technicalId,
                                   style: const TextStyle(
                                     overflow: TextOverflow.ellipsis,
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.normal,
                                   ),),
                               ]
                           )),
                       const SizedBox(height: 5,),
                       RichText(
                           text: TextSpan(
                               children: [
                                 const TextSpan(text: 'Details : ',
                                     style:  TextStyle(
                                       color: Colors.black,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                     )),
                                 TextSpan(text: cubit.ordersUserList[index].details,
                                   style: const TextStyle(
                                     overflow: TextOverflow.ellipsis,
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.normal,
                                   ),),
                               ]
                           )),
                       const SizedBox(height: 5,),
                       RichText(
                           text: TextSpan(
                               children: [
                                 const TextSpan(text: 'Status : ',
                                     style:  TextStyle(
                                       color: Colors.black,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                     )),
                                 TextSpan(text: cubit.ordersUserList[index].status,
                                   style: const TextStyle(
                                     overflow: TextOverflow.ellipsis,
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.normal,
                                   ),),
                               ]
                           )),
                       const SizedBox(height: 5,),
                       RichText(
                           text: TextSpan(
                               children: [
                                 const TextSpan(text: 'Price : ',
                                     style:  TextStyle(
                                       color: Colors.black,
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                     )),
                                 TextSpan(text: '${cubit.ordersUserList[index].price} EGP',
                                   style: const TextStyle(
                                     overflow: TextOverflow.ellipsis,
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.normal,
                                   ),),
                               ]
                           )),
                       const SizedBox(height: 10,),

                       (cubit.ordersUserList[index].isConfirm==false)?
                       Container():SizedBox(
                         width: double.infinity,
                         child: MaterialButton(
                           color: Colors.white,
                           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                           shape: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                             borderSide: BorderSide.none,
                           ),
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                 ChatScreen(idDoc: cubit.ordersUserList[index].idOrder,)));
                           },
                           child: const Text(
                             "Chat",
                             style: TextStyle(
                                 color: Colors.orange,
                                 fontSize: 23,
                                 fontWeight: FontWeight.bold),
                           ),
                         ),
                       ),
                   ],
                 ));
               }),
         );
        },
        listener: (context, state) {

        });
  }
}
