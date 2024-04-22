import 'package:flutter/material.dart';
import 'package:simulasiuts/model/model_login.dart';
import 'package:simulasiuts/page/page_bottom_navigation.dart';
import 'package:simulasiuts/page/page_register.dart';
import 'package:http/http.dart' as http;


import '../utils/session_manager.dart';

class PageLoginTugas extends StatefulWidget {
  const PageLoginTugas({super.key});

  @override
  State<PageLoginTugas> createState() => _PageLoginTugasState();
}

class _PageLoginTugasState extends State<PageLoginTugas> {
  //untuk mendapatkan value dari text field
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  //Task : Silahkan hubungkan yg page login dengan api
  //kalau berhasil dia pindah ke hal berita

  //validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //proses untuk hit api
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async {
    //handle error
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http
          .post(Uri.parse('http://192.168.43.36/edukasi_server2/login.php'), body: {
        "username": txtUsername.text,
        "password": txtPassword.text,
      });
      ModelLogin data = modelLoginFromJson(response.body);
      //cek kondisi
      if (data.value == 1) {
        //kondisi ketika berhasil login
        setState(() {
          isLoading = false;
          //untuk simpan sesi
          session.saveSession(data.value ?? 0, data.id ??"", data.username ??"");

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          //pindah ke page list Berita
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageBottomNavigationBar()),
                  (route) => false);
        });
      } else {
        //gagal
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        //munculkan error
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Form  Login'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtUsername,
                  decoration: InputDecoration(
                      hintText: 'Input Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person)
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtPassword,
                  obscureText: true, //biar password nya gak keliatan
                  decoration: InputDecoration(
                      hintText: 'Input Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock)
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : MaterialButton(
                      onPressed: () {
                        //cara get data dari text form field

                        //cek validasi form ada kosong  atau tidk
                        if (keyForm.currentState?.validate() == true) {
                          setState(() {
                            loginAccount();
                          });
                        }
                      },
                      child: Text('Login'),
                      color: Colors.green,
                      textColor: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(width: 1, color: Colors.green)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterApi()));
          },
          child: Text('Anda belum punya account? Silkan Register'),
        ),
      ),
    );
  }
}
