
import 'package:a5dmny/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  final String idDoc;
  ChatScreen({Key? key, required this.idDoc,}) : super(key: key);
  ScrollController scrollController=ScrollController();
  TextEditingController controller=TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference message = FirebaseFirestore.instance.
    collection('Orders').doc(idDoc).collection('Chat');
    return StreamBuilder<QuerySnapshot>(
        stream: message.orderBy('created',descending: true).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<ChatModel> messageList=[];
            for(int i=0;i<snapshot.data!.docs.length;i++){
              messageList.add(ChatModel.jsonDate(snapshot.data!.docs[i]));
            }
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.orange,
                  title: const Text('Chat',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          reverse: true,
                          itemCount: messageList.length,
                          itemBuilder: (context,index){
                            return  messageList[index].id==auth.currentUser!.uid?
                            BubbleChat(message: messageList[index],):
                            BubbleChatFormFriend(message: messageList[index],);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller:controller ,
                        decoration:  InputDecoration(
                          hintText: 'message',
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          suffixIcon: InkWell(
                            onTap: (){
                              message.add({
                                'message': controller.text,
                                'created':DateTime.now(),
                                'id':auth.currentUser!.uid,
                              });
                              scrollController.animateTo(
                                0,
                                duration:const Duration(milliseconds: 400),
                                curve: Curves.ease,
                              );
                              controller.clear();
                            },
                            child: const Icon(Icons.send,
                              color: Colors.orange,
                            ),
                          ),
                          focusedBorder:  const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange,
                                  width: 2
                              )
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:Colors.orange,
                                  width: 1
                              )
                          ),
                        ),
                        onSubmitted: (date){
                          message.add({
                            'message': date,
                            'created':DateTime.now(),
                            'id':auth.currentUser!.uid,
                          });
                          scrollController.animateTo(
                            0,
                            duration:const Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                          controller.clear();
                        },
                      ),
                    ),
                  ],
                )
            );
          }else{
            return const Scaffold(body: Center(child:  Text('Loading...'),));
          }
        });
  }


}

class BubbleChat extends StatelessWidget {
  BubbleChat({
    Key? key,required this.message,
  }) : super(key: key);
  final ChatModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding:const EdgeInsets.all(12),
        margin:const EdgeInsets.symmetric(
            vertical: 8,horizontal: 12
        ),
        decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            )
        ),
        child: Text(message.message,
          style:const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),),
      ),
    );
  }
}

class BubbleChatFormFriend extends StatelessWidget {
  BubbleChatFormFriend({
    Key? key,required this.message,
  }) : super(key: key);
  final ChatModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding:const EdgeInsets.all(12),
        margin:const EdgeInsets.symmetric(
            vertical: 8,horizontal: 12
        ),
        decoration:const BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            )
        ),
        child: Text(message.message,
          style:const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),),
      ),
    );
  }
}