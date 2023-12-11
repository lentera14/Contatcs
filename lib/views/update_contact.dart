import 'package:contacts_app/controllers/crud_service.dart';
import 'package:flutter/material.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact(
      {super.key,
      required this.docId,
      required this.name,
      required this.phone,
      required this.email});
  final String docId, name, phone, email;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _phoneCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameCont.text = widget.name;
    _emailCont.text = widget.email;
    _phoneCont.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Column(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color.fromARGB(255, 201, 69, 117),
                size: 40,
              ),
            ),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
        toolbarHeight: 150,
        backgroundColor: const Color.fromARGB(255, 201, 69, 117),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: formKey,
          child: Column(children: [
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              validator: (value) => value!.isEmpty ? "Provide FullName" : null,
              controller: _nameCont,
              decoration: InputDecoration(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person),
                    Text(
                      "Full Name",
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
              validator: (value) => value!.isEmpty ? "Provide Email" : null,
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
              validator: (value) => value!.isEmpty ? "Provide PH Phone" : null,
              controller: _phoneCont,
              decoration: InputDecoration(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.call),
                    Text(
                      "Phone Number",
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
                  CRUDService().updateContact(_nameCont.text, _phoneCont.text,
                      _emailCont.text, widget.docId);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Update Contact Successfully!"),
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 201, 69, 117),
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                CRUDService().deleteContact(widget.docId);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Delete Contact Successfully!"),
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 201, 69, 117),
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}