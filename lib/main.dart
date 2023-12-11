import 'package:contacts_app/controllers/auth_service.dart';
import 'package:contacts_app/firebase_options.dart';
import 'package:contacts_app/themes/theme_provider.dart';
import 'package:contacts_app/views/add_contact.dart';
import 'package:contacts_app/views/home.dart';
import 'package:contacts_app/views/login_page.dart';
import 'package:contacts_app/views/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: ((context) => ThemeProvider()), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: "/",
      routes: {
        "/": (context) => const CheckUser(),
        "/login": (context) => const LoginWid(),
        "/home": (context) => const HomePage(),
        "/signup": (context) => const SignWid(),
        "/add": (context) => const AddContact()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//check if the use is logged in or not

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.discreteCircle(
            thirdRingColor: Color.fromRGBO(192, 136, 162, 1),
            secondRingColor: Color.fromARGB(255, 229, 183, 201),
            color: const Color.fromARGB(255, 201, 69, 117),
            size: 75));
  }
}