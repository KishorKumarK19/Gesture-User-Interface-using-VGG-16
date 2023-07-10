import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:gesture_user_interface/userprofilebar.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;


class MyDropdownWidget extends StatefulWidget {
  const MyDropdownWidget({Key? key}) : super(key: key);

  @override
  _MyDropdownWidgetState createState() => _MyDropdownWidgetState();
}



class _MyDropdownWidgetState extends State<MyDropdownWidget> {
  List<String> items = ['All Text Copy', 'Paste', 'Shift to previous Tab', 'Undo', 'Minimize all apps', 'Open Settings', 'Pause/Play', 'Mute', 'Rewind','Forward'];
  
  List<List<int>> selectedValues = List.generate(6, (index) => [index]);
  bool isRunning = false;
  String? ip;

  @override
  Widget build(BuildContext context) {
    
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? username = args?['username'] as String?;
    final String? userid = args?['userid'] as String?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Gesture Classification"),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [       
            Text("UserName : $username"),
                GestureDetector(
      onTap: () {
        
        Future<Object?> myFuture =  Navigator.pushNamed(context, '/IP');
myFuture.then((result) {
  ip = result.toString();
  // Do something with myString
});
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          'Configure IP of System',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,          
          ),
        ),
      ),
    ),

            for (int i = 0; i < 6; i++)
              Column(children: [
                DropdownButton(
                  value: selectedValues[i][0],
                  onChanged: (newValue) {
                    setState(() {
                      // Remove the previously selected value from the available options for subsequent dropdowns
                      for (int j = 0; j < 6; j++) {
                        if(j!=i){
                        selectedValues[j].remove(newValue);
                        }
                      }
                      // Add back the previously selected value to the available options for the current dropdown
                      // Update the data for the document with ID 'john-doe'
                      

                  
                      // Update the selected value for the current dropdown
                      selectedValues[i][0] = newValue as int;
                    });
                    firestore.doc('gesture_options/$userid').update({
                      i.toString(): newValue, // update the value for key 0 to 10
                      })
                      .then((value) => print('$i:$newValue Data updated successfully!'))
                      .catchError((error) => print('Failed to update data: $error'));
                  },
                  items: items
                      .asMap()
                      .entries
                      .where((entry) => !selectedValues.any((values) => values.contains(entry.key)) || entry.key == selectedValues[i][0])
                      .map((entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),
              ]),
            SizedBox(height: 20),
            Switch(
              value: isRunning,
              onChanged: (value) {
                setState(() {
                  isRunning = value;
                });
                _runScript(userid);
              },
            ),
            SizedBox(height:10.0),
            ElevatedButton(
            onPressed: () => _signout(context),
            child: Text("Sign Out")),
          ],
        ),
      ),
    );
  }

  

  void _runScript(String? userid) async {
    try{
    final response = await http.get(Uri.parse('http://$ip:5000/run-script?userid=$userid'));
    
    }
    catch(e)
    {
      print(e);
    }
    print('success');

  }

void _stopScript() async {
   
   
    try{
      final response = await http.get(Uri.parse('http://$ip:5000/stopit'));
      
    }
    catch(e)
    {
      print("Error Connecting to Server $e");  
    }    
  }

  void _executePythonScript(bool value,String? userid) async {
    // Implementation of this method is omitted for brevity
    if(value){
      _runScript(userid);
    }
    else{
      _stopScript();
    }
  }
    Future<void> _signout(BuildContext context) async  {
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    }
    catch(e)
    {
      print("Error Signing out");
    }
  }
  
}
