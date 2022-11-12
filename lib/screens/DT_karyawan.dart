import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_dashboard_app_tut/resources/warna.dart';

class Karyawan extends StatefulWidget {
  const Karyawan({Key? key}) : super(key: key);

  @override
  State<Karyawan> createState() => _KaryawanState();
}

class _KaryawanState extends State<Karyawan> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String search = "";
  late TextEditingController searchController =
      TextEditingController(text: search);

  String nama = "";
  String email = "";
  String noHp = "";
  String noRekening = "";
  String alamat = "";
  bool _loading = false;

  Future editUser(String? id, BuildContext context, Function setLoad) async {
    setLoad(true);
    try {
      final docUser = FirebaseFirestore.instance.collection("users").doc(id);
      final json = {
        "email": email,
        "nama": nama,
        "no_rekening": noRekening,
        "alamat": alamat,
        "no_hp": noHp,
        "updated_at": DateTime.now(),
      };

      await docUser.update(json);

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
      // Fluttertoast.showToast(
      //     msg: "Berhasil update user.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     timeInSecForIosWeb: 2,
      //     webShowClose: true,
      //     webPosition: "right",
      //     webBgColor: "#5cb85c",
      //     gravity: ToastGravity.TOP,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  Future deleteUser(String? id, BuildContext context, Function setLoad) async {
    setLoad(true);
    try {
      final docUser = FirebaseFirestore.instance.collection("users").doc(id);

      await docUser.delete();

      Navigator.of(this.context).pop('dialog');
      setLoad(false);
      // Fluttertoast.showToast(
      //     msg: "Berhasil hapus user.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     timeInSecForIosWeb: 2,
      //     webShowClose: true,
      //     webPosition: "right",
      //     webBgColor: "#5cb85c",
      //     gravity: ToastGravity.TOP,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
      setLoad(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: search != ""
            ? firestore
                .collection("users")
                .orderBy("nama")
                .where("nama", isEqualTo: search)
                .snapshots()
            : firestore.collection("users").orderBy("nama").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Data Karyawan",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 10, right: 14, left: 1100, top: 10),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Warna.hijauht,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          child: Text("Cetak"),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Warna.abuabu,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                              child: Text("Download"),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(),
                  Container(
                    margin: EdgeInsets.only(
                        left: 900, right: 20, top: 10, bottom: 10),
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                        color: Warna.putih,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Warna.hijau2,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Warna.hijau2,
                              width: 1.0,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          )),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50, top: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DataTable(
                                  showBottomBorder: true,
                                  columnSpacing: 45,
                                  dataRowHeight: 45,
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.grey.shade200),
                                  columns: <DataColumn>[
                                    DataColumn(label: Text("No.")),
                                    DataColumn(label: Text("Nama")),
                                    DataColumn(label: Text("Alamat")),
                                    DataColumn(label: Text("No HP")),
                                    DataColumn(label: Text("No Rekening")),
                                    DataColumn(label: Text("Email")),
                                    DataColumn(label: Text("Ubah")),
                                  ],
                                  rows: List<DataRow>.generate(
                                      snapshot.data!.docs.length, (index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    final number = index + 1;

                                    return DataRow(cells: [
                                      DataCell(Text(number.toString())),
                                      DataCell(Text(data["nama"])),
                                      DataCell(Text(data['alamat'])),
                                      DataCell(Text(data['no_hp'])),
                                      DataCell(Text(data['no_rekening'])),
                                      DataCell(Text(data['email'])),
                                      DataCell(
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                child: Text('Ubah'),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.amber,
                                                    textStyle: const TextStyle(
                                                        fontSize: 16)),
                                                onPressed: () {
                                                  setState(() {
                                                    nama = data["nama"];
                                                    email = data["email"];
                                                    noHp = data['no_hp'];
                                                    noRekening =
                                                        data["no_rekening"];
                                                    alamat = data["alamat"];
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                            builder: (BuildContext
                                                                    context,
                                                                void Function(
                                                                        void
                                                                            Function())
                                                                    setState) {
                                                          return Dialog(
                                                              insetPadding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          300),
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          500,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.close,
                                                                                  color: Colors.white,
                                                                                ),
                                                                                Text(
                                                                                  "Edit User",
                                                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                                                                ),
                                                                                InkWell(
                                                                                    child: Icon(Icons.close),
                                                                                    onTap: () {
                                                                                      Navigator.of(context).pop('dialog');
                                                                                    }),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.symmetric(vertical: 30),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    TextInput("Email", false, email, (String value) {
                                                                                      setState(() {
                                                                                        email = value;
                                                                                      });
                                                                                    }),
                                                                                    TextInput("Nama", false, nama, (String value) {
                                                                                      setState(() {
                                                                                        nama = value;
                                                                                      });
                                                                                    })
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    TextInput("No HP", false, noHp, (String value) {
                                                                                      setState(() {
                                                                                        noHp = value;
                                                                                      });
                                                                                    }),
                                                                                    TextInput("No Rekening", false, noRekening, (String value) {
                                                                                      setState(() {
                                                                                        noRekening = value;
                                                                                      });
                                                                                    })
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    TextInput("Alamat", true, alamat, (String value) {
                                                                                      setState(() {
                                                                                        alamat = value;
                                                                                      });
                                                                                    }),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    primary: Colors.green,
                                                                                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                                                                                    textStyle: const TextStyle(fontSize: 16),
                                                                                  ),
                                                                                  onPressed: !_loading
                                                                                      ? () {
                                                                                          editUser(data.id, context, (bool val) {
                                                                                            setState(() {
                                                                                              _loading = val;
                                                                                            });
                                                                                          });
                                                                                        }
                                                                                      : null,
                                                                                  child: _loading
                                                                                      ? const CircularProgressIndicator(
                                                                                          strokeWidth: 2.0,
                                                                                          color: Colors.white,
                                                                                        )
                                                                                      : const Text("Submit"),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )),
                                                                ],
                                                              ));
                                                        });
                                                      });
                                                }),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            ElevatedButton(
                                              child: Text("Hapus"),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  textStyle: const TextStyle(
                                                      fontSize: 16)),
                                              onPressed: () {
                                                setState(() {
                                                  nama = data["nama"];
                                                  email = data["email"];
                                                  noHp = data['no_hp'];
                                                  noRekening =
                                                      data["no_rekening"];
                                                  alamat = data["alamat"];
                                                });
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              void Function(
                                                                      void
                                                                          Function())
                                                                  setState) {
                                                        return Dialog(
                                                            insetPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        300),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    width: 400,
                                                                    height: 240,
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "Hapus User",
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.symmetric(vertical: 30),
                                                                            child: Text(
                                                                              textAlign: TextAlign.center,
                                                                              "Apakah anda yakin menghapus user ${data["nama"]}?",
                                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                                            )),
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  primary: Colors.red,
                                                                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                                                                  textStyle: const TextStyle(fontSize: 16),
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop("dialog");
                                                                                },
                                                                                child: const Text("Close"),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  primary: Colors.green,
                                                                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                                                                  textStyle: const TextStyle(fontSize: 16),
                                                                                ),
                                                                                onPressed: !_loading
                                                                                    ? () {
                                                                                        deleteUser(data.id, context, (bool val) {
                                                                                          setState(() {
                                                                                            _loading = val;
                                                                                          });
                                                                                        });
                                                                                      }
                                                                                    : null,
                                                                                child: _loading
                                                                                    ? const CircularProgressIndicator(
                                                                                        strokeWidth: 2.0,
                                                                                        color: Colors.white,
                                                                                      )
                                                                                    : const Text("Ya"),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )),
                                                              ],
                                                            ));
                                                      });
                                                    });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  })),
                              //Now let's set the pagination
                              SizedBox(
                                height: 40.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Container TextInput(
      String? label, bool? multiline, String? value, Function? onChanged) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(label!),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            enabled: label == "Email" ? false : true,
            onChanged: ((value) {
              onChanged!(value);
            }),
            initialValue: value,
            keyboardType:
                multiline! ? TextInputType.multiline : TextInputType.none,
            maxLines: multiline ? 3 : 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ],
      ),
    );
  }
}
