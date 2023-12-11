import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_app/controllers/auth_service.dart';
import 'package:contacts_app/controllers/crud_service.dart';
import 'package:contacts_app/themes/theme_provider.dart';
import 'package:contacts_app/views/update_contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = ''; 
  callUser(String phone) async {
    String url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url ";
    }
  }

  smsUser(String phone) async {
    String url = "sms:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url ";
    }
  }

  emailUser(String email) async {
    Uri mail = Uri.parse("mailto:$email");
    if (await launchUrl(mail)) {
      //email app opened
    } else {
      //email app is not opened
    }

  }

  //darkMode is either true or false
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    //profile pic Google
    final User? user = FirebaseAuth.instance.currentUser;

    // Default values if user is null
    String photoUrl = 'image/account.png';
    // Menyimpan nilai dari inputan pencarian

    if (user != null) {
      // Update values if user is not null
      photoUrl = user.photoURL ?? photoUrl;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 201, 69, 117),
          onPressed: () {
            Navigator.pushNamed(context, "/add");
          },
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
          )),
          
      appBar: AppBar(
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
            color: Color.fromARGB(255, 253, 93, 152)
          ),
        ),
        title: const Text(
          "Contacts",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Builder(
              builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: CircleAvatar(
                      backgroundImage: user != null
                          ? (photoUrl.startsWith('http') ||
                                  photoUrl.startsWith('https'))
                              ? NetworkImage(photoUrl)
                              : AssetImage(photoUrl) as ImageProvider<Object>?
                          : AssetImage(photoUrl),
                      backgroundColor: Colors.white,
                      radius: 20,
                    ),
                  )),
        ),
        leadingWidth: 70,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Color.fromARGB(255, 253, 171, 201) // Warna untuk mode terang
      : Color.fromARGB(255, 228, 79, 133), // Warna untuk mode gelap
        
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: user != null
                      ? (photoUrl.startsWith('http') ||
                              photoUrl.startsWith('https'))
                          ? NetworkImage(photoUrl)
                          : AssetImage(photoUrl) as ImageProvider<Object>?
                      : AssetImage(photoUrl),
                  backgroundColor: Colors.white,
                  maxRadius: 42,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(FirebaseAuth.instance.currentUser!.email.toString()),
              ],
            )),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Row(children: [
                const Text("Dark Mode"),
                const SizedBox(
                  width: 60,
                ),
                FlutterSwitch(
                  activeColor: Color.fromARGB(255, 255, 191, 214),
                  width: 60,
                  height: 30,
                  padding: 6,
                  valueFontSize: 30,
                  showOnOff: false,
                  value: isOn,
                  borderRadius: 30,
                  toggleSize: 20,
                  onToggle: (val) {
                    setState(() {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                      isOn = val;
                    });
                  },
                )
              ]),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                AuthService().logout();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Logged Out"),
                ));
                Navigator.pushReplacementNamed(context, "/login");
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
            ),
          ],
        ),
      ),
      
      body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              labelText: 'Search Contacts', 
              labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
              prefixIcon: Icon(Icons.search, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
              border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color.fromARGB(255, 201, 69, 117)),), 
                            hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),          
            ),
            
          ),
        ), 
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something Went Wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      thirdRingColor: Color.fromRGBO(192, 136, 162, 1),
                      secondRingColor: Color.fromARGB(255, 229, 183, 201),
                      color: const Color.fromARGB(255, 201, 69, 117),
                      size: 75));
            }

            final filteredContacts = snapshot.data!.docs.where((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return data["name"].toLowerCase().contains(searchQuery);
            }).toList();

            return ListView(
              children: snapshot.data!.docs
                .where((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return data["name"].toLowerCase().contains(searchQuery);
              })
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateContact(
                                      docId: document.id,
                                      name: data["name"],
                                      phone: data["phone"],
                                      email: data["email"],
                                    )));
                      },
                      leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 201, 69, 117),
                      child: Text(
                        data["name"][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      data["name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data["phone"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: const Color.fromARGB(255, 201, 69, 117),
                          onPressed: () {
                            callUser(data["phone"]);
                          },
                          icon: Icon(Icons.phone),
                        ),
                        IconButton(
                          color: const Color.fromARGB(255, 201, 69, 117),
                          onPressed: () {
                            smsUser(data["phone"]);
                          },
                          icon: Icon(Icons.message), // Changed icon to message icon
                        ),
                        IconButton(
                          color: const Color.fromARGB(255, 201, 69, 117),
                          onPressed: () {
                            emailUser(data["email"]);
                          },
                          icon: Icon(Icons.email), // Changed icon to message icon
                        ),
                      ],
                    ),
                  );
                })
              .toList()
              .cast(),
            );
          },
          stream: CRUDService().getContacts(),
         ),
        ),
      ],
    ),
  );
  }
}