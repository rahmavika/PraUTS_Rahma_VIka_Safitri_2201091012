import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:simulasiuts/page/page_detail_berita.dart';

import '../model/model_berita.dart';
import '../utils/session_manager.dart';


class ListBerita extends StatefulWidget {
  const ListBerita({super.key});

  @override
  State<ListBerita> createState() => _ListBeritaState();
}

class _ListBeritaState extends State<ListBerita> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? beritaList;
  String? username;
  List<Datum>? filteredBeritaList; // List berita hasil filter

  @override
  void initState() {
    super.initState();
    session.getSession();
    getDataSession();
  }

  //untuk mendpatkan data sesi
  Future getDataSession() async{
    await Future.delayed(const Duration(seconds: 5), (){
      session.getSession().then((value) {
        print('data sesi .. ' + value.toString());
        username = session.userName;
      });
    });
  }

  //method untuk get berita
  Future<List<Datum>?> getBerita() async{
    try{
      //berhasil
      http.Response response = await
      http.get(Uri.parse("http://192.168.43.36/edukasi_server2/getBerita.php"));

      return modelBeritaFromJson(response.body).data;
      //kondisi gagal untuk mendapatkan respon api
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Aplikasi Berita'),
      //   backgroundColor: Colors.cyan,
      //   actions: [
      //     TextButton(onPressed: () {}, child: Text('Hi ... $username')),
      //     // Logout
      //     IconButton(
      //       onPressed: () {
      //         // Clear session
      //         setState(() {
      //           session.clearSession();
      //           Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => PageLoginTugas()),
      //                 (route) => false,
      //           );
      //         });
      //       },
      //       icon: Icon(Icons.exit_to_app),
      //       tooltip: 'Logout',
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredBeritaList = beritaList
                      ?.where((element) =>
                  element.judul!
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                      element.konten!
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getBerita(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.hasData) {
                  beritaList = snapshot.data;
                  if (filteredBeritaList == null) {
                    filteredBeritaList = beritaList;
                  }
                  return ListView.builder(
                    itemCount: filteredBeritaList!.length,
                    itemBuilder: (context, index) {
                      Datum data = filteredBeritaList![index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailBerita(data),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network('http://192.168.43.36/edukasi_server2/gambar_berita/${data.gambar}',
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                ),
                                ListTile(
                                  title: Text(
                                    '${data.judul}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${data.konten}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}