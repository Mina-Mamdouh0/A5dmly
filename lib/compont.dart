
import 'package:flutter/material.dart';

Widget emptyData(){
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset('assets/images/empty.png',
      width: 100,height: 100),
      const SizedBox(height: 15,),
      const Text('Empty Data',
      style: TextStyle(
        color: Colors.orange,
        fontSize: 22,
       fontWeight: FontWeight.bold,
      ),)

    ],
  );
}