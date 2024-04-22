import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simulasiuts/model/model_register.dart';
import 'package:simulasiuts/page/page_login.dart';
import 'package:http/http.dart' as http;



class RegisterApi extends StatefulWidget {
  const RegisterApi({super.key});

  @override
  State<RegisterApi> createState() => _RegisterApiState();
}

class _RegisterApiState extends State<RegisterApi> {
  //untuk mendapatkan value dari text field
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtFullname = TextEditingController();

  //validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //proses untuk hit api
  bool isLoading = false;
  Future<ModelRegisterLagi?> registerAccount() async {
    //handle error
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http
          .post(Uri.parse('http://192.168.43.36/edukasi_server2/register.php'), body: {
        "username": txtUsername.text,
        "email": txtEmail.text,
        "password": txtPassword.text,
        "fullname": txtFullname.text,
      });
      ModelRegisterLagi data = modelRegisterLagiFromJson(response.body);
      //cek kondisi
      if (data.value == 1) {
        //kondisi ketika berhasil register
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          //pindah ke page login
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageLoginTugas()),
                  (route) => false);
        });
      } else if (data.value == 2) {
        //kondisi akun sdh ada
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
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
        title: Text('Form  Register'),
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
                          borderRadius: BorderRadius.circular(10))),
                ),

                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtEmail,
                  decoration: InputDecoration(
                      hintText: 'Input Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
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
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtFullname,
                  obscureText: true, //biar password nya gak keliatan
                  decoration: InputDecoration(
                      hintText: 'Input Fullname',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

                SizedBox(
                  height: 15,
                ),
                //proses cek loading
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
                            registerAccount();
                          });
                        }
                      },
                      child: Text('Register'),
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
                MaterialPageRoute(builder: (context) =>PageLoginTugas()));
          },
          child: Text('Anda sudah punya account? Silkan Login'),
        ),
      ),
    );
  }
}
