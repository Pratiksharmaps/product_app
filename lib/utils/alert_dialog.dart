
import 'package:flutter/material.dart';

class alertdialog extends StatelessWidget {
  final String tittle;
  final String content;
  final Function() ButtonFunction;
  const alertdialog(
      {super.key,
      required this.tittle,
      required this.content,
      required this.ButtonFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      titlePadding: const EdgeInsets.fromLTRB(20, 15, 0, 1),
      shape: const RoundedRectangleBorder(),
      title: Text(tittle),
      titleTextStyle: const TextStyle(
          fontSize: 23, fontWeight: FontWeight.bold, color:Colors.black),
      contentTextStyle: const TextStyle(color: Colors.black, fontSize: 15),
      actionsAlignment: MainAxisAlignment.end,
      content: Text(content),
      actions: [
         GestureDetector(
          onTap: ButtonFunction,
           child: const Padding(
             padding: EdgeInsets.all(4.0),
             child: Text(
               "OK",
               style: TextStyle(
                   color: Colors.black,
                   fontSize: 17,
                   fontWeight: FontWeight.bold),
             ),
           ),
         ),
        
      ],
    );
  }
}
void showAlertDialogBox(BuildContext context, String tittle, String content,
    Function() buttonFunction) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return alertdialog(
          tittle: tittle,
          content: content,
          ButtonFunction: buttonFunction,
        );
      }));
}

void hideProgressDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
