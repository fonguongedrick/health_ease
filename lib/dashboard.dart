import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'Book_appointments.dart';
import 'results.dart';

class DashboardScreen extends StatefulWidget {
  final String name;
  final int userId;
  final String email;
  final String school;
  final String password;
  final String mrNumnder;
   
  const DashboardScreen({
    required this.userId,
    required this.name,
    required this.email,
    required this.school,
    required this.password,
    required this.mrNumnder

  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
 
  String pdfFilePath = '/assets/PHY201.pdf';
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
void initState() {
  super.initState();
  _pages = [
    HomeScreen(Name: widget.name),
    PastQuestionsScreen(),
    ProfilePage(
      userId: widget.userId,
      name: widget.name,
      email: widget.email,
      school: widget.school,
      password: widget.password,
    ),
  ];
}

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }
 Future<void> logoutUser(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog dismissal on tap outside
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Logging out...',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    },
  );

  try {
    // Clear user authentication data (example using SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('password');
    await prefs.remove('userId');
    await prefs.remove('school');
    await prefs.remove('email');
    await prefs.remove('LoggedIn'); // Replace 'userId' with your actual user ID key

    // After clearing the data, navigate the user back to the login screen
    Navigator.pop(context); // Dismiss the loading dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  } catch (error) {
    // Handle any errors that might occur during the logout process
    print('Error during logout: $error');
    Navigator.pop(context); // Dismiss the loading dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Error'),
          content: Text('An error occurred while logging out. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Dashboard',
        style: TextStyle(color: Colors.black),),
        centerTitle: true,
        // Change the leading widget to a menu icon
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.blue,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
            
          },
        ),
        actions: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.notifications,
                color: Colors.blue,
              ),
              onPressed: () {
               /*Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationPage(
      
    ),
  ),
); */// Handle notification button press
              },
            ),
        
     ] ),
      // Add a Drawer widget to the Scaffold
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(0),
          color: Colors.grey[300],
          child: Column(
            
            children: [
               // Add a DrawerHeader widget
              DrawerHeader(
  decoration: BoxDecoration(
    color: Colors.blue,
  ),
  child: Column(
    children: [
     SizedBox(height: 100,),
     //Image.asset('assets/health_ease-removebg-preview.png', height:200, width:200,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
           GestureDetector(
            onTap: () {
            Navigator.of(context).pop(); 
            },
            child: Icon(
              Icons.cancel,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  ),
),
              // Add Drawer items
ListTile(
              leading: Icon(Icons.home, color: Colors.blue,),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).pop();  
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month, color: Colors.blue,),
              title: Text('Book Appointment'),
              onTap: () {
                Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookAppointmentPage(userId: widget.userId, name :widget.name,
        email: widget.email,
        school: widget.school,
        password: widget.password )),
      );/// Navigate to Past Questions screen
              },
            ),
            ListTile(
              leading: Icon(Icons.error, color: Colors.blue,),
              title: Text('Lab Results'),
              onTap: () {
                Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => ResultsPage()),
                         
                        );
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue,),
              title: Text('Profile'),
              onTap: () {
               Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(userId: widget.userId, name :widget.name,
        email: widget.email,
        school: widget.school,
        password: widget.password ),
                          ),
                        ); // Navigate to Profile screen
              },
            ),
            SizedBox(height: 185,),
Padding(
  padding: const EdgeInsets.only(left:28.0, bottom : 10),
  child: Align(
    alignment: Alignment(0,-100),
    child: ListTile(
     titleAlignment: ListTileTitleAlignment.bottom,
    title: Row(
  
      children: [
  
        Icon(Icons.logout, color: Colors.blue),
  
        SizedBox(width: 10),
  
        Text('Logout'),
  
      ],
  
    ),
  
    onTap: () {
  
    logoutUser(context);

  
    },
  
  ),
  ),

), 
         ]))), 
         body: Container(
           color: Colors.white,
           padding: EdgeInsets.all(16),
           child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Container(
                     height: 110,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12),
                       color: Colors.blue
                     ),
                     padding: EdgeInsets.all(16),
                     child: Row(
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               'Welcome  ${widget.name}',
                               style: TextStyle(fontSize: 16, color: Colors.white),
                               
                             ),
                             
                             SizedBox(height: 18),
                             Expanded(
                               child: Text(
                                 'MR Number: ${widget.mrNumnder}', 
                                 style: TextStyle(fontSize: 16,color: Colors.white),
                               ),
                             ),
                           ],
                         ),
                         Expanded(child: Image.asset('assets/health_ease-removebg-preview.png', height:350, width:180,))
                       ],
                     ),
                   ),
                   SizedBox(height: 32),
                   Text(' Last Three Appointmens', style: TextStyle(fontWeight: FontWeight.bold),),
                 SizedBox(height: 20,),
                 Container(
         padding: EdgeInsets.all(16),
         decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
               color: Colors.grey[200],
         ),
         child: Row(
               children: [
                 SizedBox(height: 8),
                 Expanded(
                   child: Text(
                     'Reason for Appointment',
                     
                   ),
                 ),
                 SizedBox(width: 46),
                 Expanded(
                   child: Column(
                     children: [
                       Text(
                         '15/09/2023  status: ',
                       ),
                       Text('Pending', style: TextStyle(color: Colors.red),)
                     ],
                   ),
                 ),
               ],
         ),
    ),
    SizedBox(height: 16,),
                      Container(
         padding: EdgeInsets.all(16),
         decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
               color: Colors.grey[200],
         ),
         child: Row(
               children: [
                 SizedBox(height: 8),
                 Expanded(
                   child: Text(
                     'Reason for Appointment',
                     
                   ),
                 ),
                 SizedBox(width: 46),
                 Expanded(
                   child: Column(
                     children: [
                       Text(
                         '15/09/2023  status: ',
                       ),
                       Text('Pending', style: TextStyle(color: Colors.red),)
                     ],
                   ),
                 ),
               ],
         ),
    ),
    SizedBox(height: 16,),
                    Container(
         padding: EdgeInsets.all(16),
         decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(16),
               color: Colors.grey[200],
         ),
         child: Row(
               children: [
                 SizedBox(height: 8),
                 Expanded(
                   child: Text(
                     'Reason for Appointment',
                     
                   ),
                 ),
                 SizedBox(width: 46),
                 Expanded(
                   child: Column(
                     children: [
                       Text(
                         '15/09/2023  status: ',
                       ),
                       Text('Pending', style: TextStyle(color: Colors.red),)
                     ],
                   ),
                 ),
               ],
         ),
    ),
    // SizedBox(height: 70,),
                   
                 ],
               ),
               SizedBox(height: 90,),
                Container(
                       decoration: BoxDecoration(
                         color: Colors.blue,
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: TextButton(
                         onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppointmentPage(userId: widget.userId, name :widget.name,
        email: widget.email,
        school: widget.school,
        password: widget.password ),
                            ),
                          );
                         },
                         child: Text(
                           'New Appointment?',
                           style: TextStyle(color: Colors.white),
                         ),
                       ),
                     ),
             ],
           ),
         ),);
  }
}

class HomeScreen extends StatelessWidget {
  String pdfFilePath = '/assets/PHY201.pdf';
  late String Name;
  HomeScreen({required this.Name});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.lightBlue
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome $Name',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    
                  ),
                  
                  SizedBox(height: 18),
                  Expanded(
                    child: Text(
                      'MR Number:', 
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('')
          ],
        ),
      ),
    );
  }
}

class PastQuestionsScreen extends StatefulWidget {
  @override
  State<PastQuestionsScreen> createState() => _PastQuestionsScreenState();
}

class _PastQuestionsScreenState extends State<PastQuestionsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Past Questions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}





class ProfilePage extends StatefulWidget {
  final int userId;
  final String name;
  final String email;
  final String school;
  final String password;

  ProfilePage({
    required this.userId,
    required this.name,
    required this.email,
    required this.school,
    required this.password,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String newName = '';
  late String newSchool = '';
  late String newPassword = '';

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';

    for (String part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }

    return initials;
  }

  void updateUserProfile() async {
    // Construct the request body
    Map<String, dynamic> requestBody = {
      'userId': widget.userId,
      'name': newName,
      'school': newSchool,
      'password': newPassword,
    };

    // Send the request to the server
    final response = await http.post(
      Uri.parse('https://icademia.me/gce_qs/api/profile_update.php'), // Replace with your server endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
      final jsonData = jsonDecode(response.body);
     print(jsonData);
    // Handle the response
    if (response.statusCode == 200) {
      // Profile update successful
      showPopup('Profile Updated Successfully');
    } else {
      // Profile update failed
      showPopup('Failed to Update Profile. Please try again.');
    }
  }

  void showPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Update'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left:24, right: 24, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.lightBlue,
              child: Text(
                getInitials(widget.name),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                initialValue: widget.name,
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(top: 16, left: 8),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Text('${widget.email}'),
            ),
            SizedBox(height: 16),
            Text(
              'Pone Number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                initialValue: widget.school,
                onChanged: (value) {
                  newSchool = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                initialValue: widget.password,
                onChanged: (value) {
                  newPassword = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            SizedBox(height: 24),
           Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
  ),
  child: TextButton(
    onPressed: () async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal on tap outside
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.grey,
            child: Container(
              color: Colors.grey,
              height: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Updating...',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        },
      );

       updateUserProfile(); // Wait for the login process to complete

    },
    child: Text(
      'Update ',
      style: TextStyle(color: Colors.white),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}