import 'package:flutter/material.dart';
import 'package:freevid/Model/Event_Model.dart';
import 'package:freevid/api/apis.dart';

class Helpers{
  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_)=>const Center(child: CircularProgressIndicator()));
  }
  static void showSnackBar(BuildContext context,String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,), backgroundColor: color,behavior: SnackBarBehavior.floating,));
  }
  static void showsDialog(BuildContext context, CreateEvents createEvents){
    showDialog(context: context, builder:(BuildContext context){
          return AlertDialog(
            title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this event?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {

                    APIs().deleteEvent(createEvents.EventId, context);


                },
                child: Text('Delete'),
              ),
            ],
          );
    });
  }
}