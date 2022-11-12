import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_dashboard_app_tut/resources/warna.dart';
import 'package:intl/intl.dart';

class Presensi extends StatefulWidget {
  const Presensi({Key? key}) : super(key: key);

  @override
  State<Presensi> createState() => _PresensiState();
}

class _PresensiState extends State<Presensi> {
  DateTime selectedPeriod = DateTime.now();
  bool show = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String search = "";
  late TextEditingController searchController =
      TextEditingController(text: search);

  String nama = "";
  String email = "";
  String checkin = "";
  String checkout = "";
  String createdat = "";
  String tanggal = "";
  String keterangan = "";
  bool loading = false;

  Future<DateTime> _selectPeriod(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedPeriod,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (selected != null && selected != selectedPeriod) {
      setState(() {
        selectedPeriod = selected;
      });
    }
    return selectedPeriod;
  }

  // Future editUser(String? id, BuildContext context, Function setLoad) async {
  //   setLoad(true);
  //   try {
  //     final docUser = FirebaseFirestore.instance.collection("presensi").doc(id);
  //     final json = {
  //       "email": email,
  //       "nama": nama,
  //       "checkin": checkin,
  //       "checkout": checkout,
  //       "tanggal": tanggal,
  //       "keterangan": keterangan,
  //       "updated_at": DateTime.now(),
  //     };
  //     await docUser.update(json);

  //     Navigator.of(this.context).pop('dialog');
  //     setLoad(false);
  //   } on FirebaseException catch (e) {
  //     Navigator.of(this.context).pop('dialog');
  //     setLoad(false);
  //   }
  // }

  // Future deleteUser(String? id, BuildContext context, Function setLoad) async {
  //   setLoad(true);
  //   try {
  //     final docUser = FirebaseFirestore.instance.collection("presensi").doc(id);

  //     await docUser.delete();

  //     Navigator.of(this.context).pop('dialog');
  //     setLoad(false);
  //   } on FirebaseException catch (e) {
  //     Navigator.of(this.context).pop('dialog');
  //     setLoad(false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: search != ""
            ? firestore.collection("absen").snapshots()
            : firestore.collection("absen").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Data Presensi",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, right: 20),
                    //margin: EdgeInsets.symmetric(horizontal: 30),
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(selectedPeriod),
                          style: TextStyle(
                              color: Warna.hijau2,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            icon: Icon(Icons.keyboard_arrow_down),
                            color: Warna.hijau2,
                            onPressed: () {
                              _selectPeriod(context);
                              show = true;
                            }),
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
                    padding: EdgeInsets.only(bottom: 50, top: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
                                  columnSpacing: 45,
                                  horizontalMargin: 12,
                                  showCheckboxColumn: false,
                                  dataRowHeight: 45,
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.grey.shade200),
                                  columns: <DataColumn>[
                                    DataColumn(label: Text("No")),
                                    DataColumn(label: Text("Id")),
                                    DataColumn(label: Text("Nama")),
                                    DataColumn(label: Text("Waktu Datang")),
                                    DataColumn(label: Text("Waktu Pulang")),
                                    DataColumn(label: Text("Keterangan")),
                                    DataColumn(label: Text("Durasi")),
                                    DataColumn(label: Text("Lembur")),
                                    DataColumn(label: Text("Upah Lembur")),
                                    DataColumn(label: Text("Keterlambatan")),
                                    DataColumn(
                                        label: Text("Upah Keterlambatan")),
                                  ],
                                  rows: List<DataRow>.generate(
                                      snapshot.data!.docs.length, (index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    final number = index + 1;

                                    return DataRow(cells: [
                                      DataCell(Text(number.toString())),
                                      DataCell(Text(data["month"])),
                                      DataCell(Text(data['nama'])),
                                      DataCell(Text(
                                          DateFormat('dd-MM-yyy-hh:mm')
                                              .format(data['check_in'].toDate())
                                              .toString())),
                                      DataCell(Text(DateFormat(
                                              'dd-MM-yyy-hh:mm')
                                          .format(data['check_out'].toDate())
                                          .toString())),
                                      DataCell(Text(data['email'])),
                                      DataCell(Text(data['email'])),
                                      DataCell(Text(data['email'])),
                                      DataCell(Text(data['email'])),
                                      DataCell(Text(data['email'])),
                                      DataCell(Text(data['email'])),
                                    ]);
                                  }),
                                ),
                                //Now let's set the pagination
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ],
                        ),
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
