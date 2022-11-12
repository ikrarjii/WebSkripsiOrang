import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_dashboard_app_tut/resources/warna.dart';
import 'package:intl/intl.dart';

class Pengajuan extends StatefulWidget {
  const Pengajuan({Key? key}) : super(key: key);

  @override
  State<Pengajuan> createState() => _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  int _counter = 0;
  String? dropDownValue = "Izin";
  List<String> citylist = [
    'Izin',
    'Kasbon',
  ];

  DateTime selectedPeriod = DateTime.now();
  bool show = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String search = "";
  late TextEditingController searchController =
      TextEditingController(text: search);

  String nama = "";
  String email = "";
  String jenis = "";
  String createdat = "";
  String tanggal_mulai = "";
  String tanggal_selesai = "";
  String keterangan = "";
  String jumlah = "";
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

  Future submit(String? status, String? id, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final doc = FirebaseFirestore.instance.collection("pengajuan").doc(id);
      final json = {
        "status": status,
      };
      await doc.update(json);
      Navigator.of(this.context).pop('dialog');
    } on FirebaseException catch (e) {
      Navigator.of(this.context).pop('dialog');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: firestore
            .collection("pengajuan")
            .where("tipe_pengajuan", isEqualTo: dropDownValue)
            .get(),
        // stream: search != ""
        //     ? firestore
        //         .collection("pengajuan")
        //         .where("tipe_pengajuan", isEqualTo: dropDownValue)
        //         .snapshots()
        //     : firestore
        //         .collection("pengajuan")
        //         .where("tipe_pengajuan", isEqualTo: "Izin")
        //         .orderBy("email")
        //         .snapshots(),
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
                          "Data Pengajuan Karyawan",
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
                    margin: EdgeInsets.only(left: 17, right: 1100),
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Warna.abuabu),
                              hintText: "Izin / Kasbon",
                              fillColor: Warna.putih),
                          value: dropDownValue,
                          // ignore: non_constant_identifier_names
                          onChanged: (String? Value) {
                            setState(() {
                              dropDownValue = Value ?? "";
                            });
                          },
                          items: citylist
                              .map((cityTitle) => DropdownMenuItem(
                                  value: cityTitle, child: Text(cityTitle)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 900, right: 20),
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
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
                                  columnSpacing: 65,
                                  horizontalMargin: 13,
                                  showCheckboxColumn: false,
                                  dataRowHeight: 48,
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.grey.shade200),
                                  columns: <DataColumn>[
                                    DataColumn(label: Text("No")),
                                    DataColumn(label: Text("Nama")),
                                    DataColumn(
                                        label: Text("Tanggal Pengajuan")),
                                    DataColumn(label: Text("Jenis")),
                                    DataColumn(label: Text("Keterangan")),
                                    DataColumn(label: Text("Biaya")),
                                    DataColumn(label: Text("Tanggal Mulai")),
                                    DataColumn(label: Text("Tanggal Selesai")),
                                    DataColumn(label: Text("Status")),
                                  ],
                                  rows: List<DataRow>.generate(
                                      snapshot.data!.docs.length, (index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    final number = index + 1;

                                    return DataRow(cells: [
                                      DataCell(Text(number.toString())),
                                      DataCell(Text(data["nama"])),
                                      DataCell(Text(DateFormat('dd MMMM yyyy')
                                          .format(data['created_at'].toDate())
                                          .toString())),
                                      DataCell(Text(data["jenis"])),
                                      DataCell(Text(data['keterangan'])),
                                      DataCell(Text("Rp ${data['biaya']}")),
                                      DataCell(data['tipe_pengajuan'] == 'Izin'
                                          ? Text(DateFormat('dd MMMM yyyy')
                                              .format(data['tanggal_mulai']
                                                  .toDate())
                                              .toString())
                                          : Text('-')),
                                      DataCell(data['tipe_pengajuan'] == 'Izin'
                                          ? Text(DateFormat('dd MMMM yyyy')
                                              .format(data['tanggal_selesai']
                                                  .toDate())
                                              .toString())
                                          : Text('-')),

                                      DataCell(Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 75, vertical: 4)),
                                          data['status'] == "0"
                                              ? Row(
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.green,
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                      child: Text("Setujui"),
                                                      onPressed: () {
                                                        submit("1", data.id,
                                                            context);
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.red,
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                      child: Text("Tolak"),
                                                      onPressed: () {
                                                        submit("-1", data.id,
                                                            context);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : data['status'] == '1'
                                                  ? Container(
                                                      color: Colors.green,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Disetujui',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      color: Colors.red,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Ditolak',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                        ],
                                      )),

                                      // DataCell(Text(data['jenis'])),
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
