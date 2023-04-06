
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,index){
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
                },
                icon: const Icon(Icons.arrow_back,color: Colors.white),
              ),
            ),
            body: ListView.builder(
              physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemCount: cubit.notificationList.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(cubit.notificationList[index].image),
                        ),
                        const SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cubit.notificationList[index].name,style: TextStyle(
                                  fontWeight: FontWeight.bold,color: Colors.orange,
                                   fontSize: 20
                                ),),
                                Text(cubit.notificationList[index].typeAccount,style: TextStyle(
                                  fontWeight: FontWeight.normal,color: Colors.black,
                                   fontSize: 18
                                ),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cubit.notificationList[index].phone,style: TextStyle(
                                    fontWeight: FontWeight.normal,color: Colors.black,
                                    fontSize: 18
                                ),),
                                Text(cubit.notificationList[index].country,style: TextStyle(
                                  fontWeight: FontWeight.normal,color: Colors.black,
                                   fontSize: 18
                                ),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Text(cubit.notificationList[index].timestamp.toDate().toString(),style: TextStyle(
                                fontWeight: FontWeight.normal,color: Colors.black,
                                fontSize: 18
                            ),),

                          ],
                        )),
                      ],
                    ),
                  );
                })
          );
        },
        listener: (context,index){});
  }
}
