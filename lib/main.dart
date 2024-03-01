import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goup8_app/components/my_button.dart';
import 'package:goup8_app/components/my_textfield.dart';
import 'firebase_options.dart';
import 'package:goup8_app/Pages/account_page.dart';
import 'package:goup8_app/Pages/GroupPages/group_page.dart';
import 'package:goup8_app/Pages/map_page.dart';
import 'package:goup8_app/Pages/schedule/schedule_page.dart';
import 'package:goup8_app/Pages/search_page.dart';

import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;
  handleDeviceAccount();

  runApp(const MyApp());
}

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId; // Androidの場合、androidIdを取得
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor; // iOSの場合、identifierForVendorを取得
  }
  return '';
}

void handleDeviceAccount() async {
  String deviceId = await getDeviceId();
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    UserCredential userCredential = await auth.signInAnonymously();
    User? user = userCredential.user;

    Timestamp lastLoginTime =
        Timestamp.fromDate(user?.metadata?.lastSignInTime ?? DateTime.now());

    await FirebaseFirestore.instance.collection('User').add(
      {
        'email': user?.email,
        'createAt': Timestamp.now(),
        'lastLoginTime': lastLoginTime,
      },
    );
  } catch (e) {
    print("Anonymous login error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setLogoutTimer();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            // ログイン状態に応じて遷移
            return snapshot.hasData
                ? const MyHomePage(title: 'HOME')
                : AuthPage();
          }
        },
      ),
    );
  }

  void setLogoutTimer() {
    const logoutDuration = Duration(minutes: 10); // ログアウトまでの時間
    Timer(logoutDuration, () async {
      await FirebaseAuth.instance.signOut();
    });
  }
}

class LoginPage extends StatelessWidget {
  final SignUpModel model;
  LoginPage({Key? key, required this.model}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void logUserIn(BuildContext context) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final uid = result.user?.uid;

      // ログイン成功時の処理
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'HOME')),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage = 'ログインエラーが発生しました。';
      if (e.code == 'user-not-found') {
        errorMessage = 'アカウントが見つかりません';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'パスワードが違います';
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ログインエラー'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void signUserIn(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final email = userCredential.user?.email;
      FirebaseFirestore.instance.collection('User').add(
        {
          'email': email,
          'createAt': Timestamp.now(),
        },
      );
    } catch (e) {
      _showDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (text) {},
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // パスワードリセットのための処理をここに追加
                          void _resetPassword() async {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                email: emailController.text,
                              );
                              // パスワードリセットメールが正常に送信された場合の処理
                              _showDialog(context, 'パスワードリセットメールを送信しました。');
                            } catch (e) {
                              print('パスワードリセットエラー: $e');
                              _showDialog(context, 'パスワードリセットに失敗しました。');
                            }
                          }

                          _resetPassword();
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                LoginButton(
                  onTap: () => logUserIn(context),
                ),
                const SizedBox(height: 10),
                SigninButton(
                  onTap: () => signUserIn(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, String title) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                // 新しい画面に遷移（ログインページに遷移）
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const MyHomePage(
              title: 'HOME',
            );
          } else {
            return ChangeNotifierProvider(
              create: (context) => SignUpModel(),
              child: LoginPage(
                model: SignUpModel(),
              ),
            );
          }
        },
      ),
    );
  }
}

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    try {
      if (mail.isEmpty) {
        throw ('メールアドレスを入力してください');
      }
      if (password.isEmpty) {
        throw ('パスワードを入力してください');
      }
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      final email = userCredential.user?.email;

      FirebaseFirestore.instance.collection('User').add(
        {
          'email': email,
          'createAt': Timestamp.now(),
        },
      );
    } catch (e) {
      print("Sign-up error: $e");
      throw e;
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final _pageWidgets = {
    const MapPage(),
    const SearchPage(),
    const SchedulePage(),
    const GroupPage(),
    const AccountPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.pin_drop), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_calendar), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Group'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.white,
        backgroundColor: Colors.blue,
        iconSize: 30,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // ログアウトボタン（Account）がタップされた場合※サインアウトボタンがなかったのでアカウントで代用してるだけいずれ消す
    if (index == 4) {
      _signOut();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
