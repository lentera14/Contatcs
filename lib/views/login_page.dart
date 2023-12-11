import 'package:contacts_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class LoginWid extends StatefulWidget {
  const LoginWid({super.key});

  @override
  State<LoginWid> createState() => _LoginWidState();
}

class _LoginWidState extends State<LoginWid> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _passCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Image.asset(
              'image/phone.png',
              width: 100,
              height: 100,
            ),
            toolbarHeight: 150,
            backgroundColor: const Color.fromARGB(255, 201, 69, 117),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            )),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Email Cannot be Empty" : null,
                  controller: _emailCont,
                  decoration: InputDecoration(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.email),
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Teks putih saat dark mode
                              : Colors.black, // Teks hitam saat light mode
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color.fromARGB(255, 201, 69, 117)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Password Must Atleast 8 Characters" : null,
                  obscureText: true,
                  controller: _passCont,
                  decoration: InputDecoration(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.password),
                        Text(
                          "Password",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Teks putih saat dark mode
                              : Colors.black, // Teks hitam saat light mode
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color.fromARGB(255, 201, 69, 117)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      AuthService()
                          .loginWithEmail(_emailCont.text, _passCont.text)
                          .then((value) {
                        if (value == "Login Successful") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Login Successful"),
                          ));
                          Navigator.pushReplacementNamed(context, "/home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.shade400,
                          ));
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 201, 69, 117),
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Sign in Using"),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService().continueWithGoogle().then((value) {
                      if (value == "Google Login Successful") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Google Login Successful"),
                        ));
                        Navigator.pushReplacementNamed(context, "/home");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            value,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red.shade400,
                        ));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage("image/google-icon.png"),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Center(
                          child: Text(
                            "Google",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Don't have a account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Color.fromARGB(255, 201, 69, 117),
                              fontWeight: FontWeight.bold),
                        )
                      )
                  ],
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}