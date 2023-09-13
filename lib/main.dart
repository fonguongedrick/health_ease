import 'dart:convert';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
class ProfileData {
String data;

ProfileData(this.data);
}

class ProfileDataNotifier extends ChangeNotifier {
  ProfileData? _profileData;

  ProfileData get profileData => _profileData!;

  set profileData(ProfileData profileData) {
    _profileData = profileData;
    notifyListeners();
  }

  void updateProfileData(ProfileData profileData) {
    _profileData = profileData;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkLoginStatus();
}

Future<void> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('LoggedIn') ?? false;
  String name = prefs.getString('name') ?? '';
  int userId = prefs.getInt('userId') ?? 0;
  String school = prefs.getString('school') ?? '';
  String password = prefs.getString('password') ?? '';
  String email = prefs.getString('email') ?? '';
  String mrNumnder =prefs.getString('mr_number') ?? '';

  if (loggedIn) {
    
      runApp(
        ChangeNotifierProvider(
          create: (context) => ProfileDataNotifier(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: DashboardScreen(
              userId: userId,
              name: name,
          email: email,
          school: school,
          password: password,
          mrNumnder: mrNumnder,
            ),
          ),
        ),
      );
    }  else {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: My(),
      ),
    );
  }
}




class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: My(),
    );
  }
}


class My extends StatefulWidget {
 

  @override
  State<My> createState() => _My();
}

class _My extends State<My> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                FirstScreen(pageController: _pageController),
                MySecondScreen(pageController: _pageController),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PageIndicator(
                  totalDots: 2,
                  currentPage: _currentPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int totalDots;
  final int currentPage;

  PageIndicator({required this.totalDots, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  final PageController pageController;

  FirstScreen({required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                // Go to the login page.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.blue,),
              ),
            ),
          ),
          SizedBox(height: 30),
          Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/healthease.png', height:250, width:250,)),
              Text(
                'WELCOME',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16,),
               Text(
                'Book your appointments wih ease',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 125,),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:18.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: IconButton(onPressed: () {
                      pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                    }, icon: Icon(Icons.arrow_forward, color: Colors.white,),) ,
                  ),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ],
      ),
     
    );
  }
}


class MySecondScreen extends StatelessWidget {
  final PageController pageController;

  MySecondScreen({required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              Image.asset('assets/Blood test-amico.png', height:250, width:250),
              SizedBox(height: 10),
              Text(
                'Get your lab results on your phone',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 150),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: IconButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                    }, icon: Icon(Icons.arrow_forward, color: Colors.white,),) ,
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

  