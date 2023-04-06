
import 'package:a5dmny/bloc/app_cubit.dart';
import 'package:a5dmny/bloc/app_state.dart';
import 'package:a5dmny/compont.dart';
import 'package:a5dmny/screen/chat_screen.dart';
import 'package:a5dmny/screen/details_order_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';


class HomeTecScreen extends StatelessWidget {
  const HomeTecScreen({Key? key}) : super(key: key);
  static final List<String> offerImages = [
    'assets/images/homeone.jpeg',
    'assets/images/hometwo.jpeg',
    'assets/images/homethree.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return RefreshIndicator(
            onRefresh: ()async{
              cubit.getDateOrdersFinishTechnical();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: Marquee(
                      text: 'Welcome ${cubit.userModel==null?'':cubit.userModel!.name} to A5dmny   ',
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 200,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Image.asset(
                          offerImages[index],
                          fit: BoxFit.fill,
                        );
                      },
                      autoplay: true,
                      itemCount: offerImages.length,
                      pagination: const SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              color: Colors.white, activeColor: Colors.red)),
                      // control: const SwiperControl(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Padding(
                    padding:EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Finish Orders',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 25
                      ),),
                  ),
                  const SizedBox(height: 10,),
                  (cubit.ordersFinishTechnicalList.isEmpty)?
                  Align(
                    alignment: Alignment.center,
                    child: emptyData(),
                  ):
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.ordersFinishTechnicalList.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context,index){
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all( 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange,width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      children: [
                                        const TextSpan(text: 'Order Id : ',
                                            style:  TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(text: cubit.ordersFinishTechnicalList[index].idOrder,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.orange,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),),
                                      ]
                                  )),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(cubit.ordersFinishTechnicalList[index].imageOrder),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(cubit.ordersFinishTechnicalList[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 20
                                    ),),

                                ],
                              ),
                              const SizedBox(height: 5,),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                        const TextSpan(text: 'Technical Id : ',
                                            style:  TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(text: cubit.ordersFinishTechnicalList[index].userId,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.orange,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),),
                                      ]
                                  )),
                              const SizedBox(height: 5,),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                        const TextSpan(text: 'Location Orders : ',
                                            style:  TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(text: cubit.ordersFinishTechnicalList[index].currentLocation,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.orange,
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
                                        TextSpan(text: '${cubit.ordersFinishTechnicalList[index].price} EGP',
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.orange,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),),
                                      ]
                                  )),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            ChatScreen(idDoc: cubit.ordersFinishTechnicalList[index].idOrder,)));
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
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child: MaterialButton(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            MoreDetailOrder(orderModel: cubit.ordersFinishTechnicalList[index],isConfirmed: true,)));
                                      },
                                      child: const Text(
                                        "Details",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        );
                      }),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
        listener: (context, state){});
  }
}


