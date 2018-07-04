import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "¿Necesitas algo? ¡Escanéalo! :D";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        if (qrResult.contains('http')) {
          result = _launchURL(qrResult);
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "El permiso de cámara fue denegado";
        });
      } else {
        setState(() {
          // result = "Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "¿Necesitas algo? ¡Escanéalo! :)";
      });
    } catch (ex) {
      setState(() {
        // result = "Error $ex";
      });
    }
  }

  _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'No es posible abrir el enlace $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Little Bro',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: Text("Little Bro - Pizza & Bar"),
        ),
        body: Center(
          child: Text(result, style: new TextStyle(fontSize: 22.0)),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Pedir Algo"),
          onPressed: _scanQR,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
