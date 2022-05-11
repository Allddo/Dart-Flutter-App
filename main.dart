import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_flutter/qr_flutter.dart';

/*
Packages are:
  * Pin_code_field which is very customizable. You can have it blink, and background images that hide
    the fields in which you enter the password and they are seperate fields as well as duration for the
    blinking effect. First you create a passcode and then you enter it and will only pass through
    to the next page if the password you enter is correct.This app resembles the first time you use
    the app which is why it asks to create password.

  *The next effect is a QR-effect that deals with creating a qr code which yields one on the page and
  when scanned it reveals the data which can be anything. My implementation is to keep any link to an
  account of yours. Typically its a hard time for people to find you by username if it is random so
  it is a qr code for you to give to other people without the hassle of not being able to hear someone,
  if you are in a library, deaf, or to avoid confusion. It has a passcode so noone can just go on your
  phone and get your account information. I used my github account link.
*/

String password = '0000';
String password2 = '0000';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routes',
      initialRoute: '/',routes: {
      '/two': (context) => const enterPassword(),
      '/three': (context) => const homePage(),
      },
      home: const MyHomePage(title: 'Secret Space'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(50),
                child: Align(
                alignment: Alignment.center,
                child: Text("CREATE PASSWORD BELOW",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                )
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: TextField(
                style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter 4 Digit Code Here...',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(0.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0
                    ),
                  ),
                ),
                controller: myController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: TextField(
                style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Re-Enter 4 Digit Code Here...',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(1.0),
                    ),
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0
                    ),
                  ),
                ),
                controller: myController2,
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.lightBlueAccent),
                onPressed: (){
                  password = myController.text;
                  password2 = myController2.text;
                  if(password == password2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const enterPassword(),
                        ),
                      );
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the that user has entered by using the
                          // TextEditingController.
                          content: Text('ERROR: Passwords do not match.'),
                        );
                      },
                    );
                  }
                },
                child: Text('Confirm Password'))
          ],
        )
    );
  }
}

class enterPassword extends StatefulWidget {
  const enterPassword({Key? key}) : super(key: key);

  @override
  State<enterPassword> createState() => _enterPassword();
}

class _enterPassword extends State<enterPassword>{

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(50),
                child: Text("Enter a password below.", style: TextStyle( fontWeight:FontWeight.bold, fontSize: 30)),
            ),
            Form(
              key: formKey,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 75),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: true,
                    obscuringCharacter: '*',
                    obscuringWidget: Image.asset('assets/images/image.jpg'),
                    blinkWhenObscuring: false,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 4) {
                        return "Enter 4 Digits";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 40,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 200),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.grey,
                        blurRadius: 20,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("4 characters entered");
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                  )),
            ),
            Container(
              margin:
              const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
              child: ButtonTheme(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                    if (currentText.length != 4 || (currentText != password) && currentText != password2) {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => hasError = true);
                    } else {
                      setState(
                            () {
                          hasError = false;
                          snackBar("User Verified!");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const homePage(),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Center(
                      child: Text("ENTER",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(1, 2),
                        blurRadius: 8),
                    BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(-1, 2),
                        blurRadius: 8)
                  ]),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.black),
                  child: const Text("Clear Entered Text"),
                  onPressed: () {
                    textEditingController.clear();
                    },
            )
          ],
        )
    );
  }

}

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePage();
}

class _homePage extends State<homePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
          ),
          body: Container(
            color: Colors.blueGrey,
              child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: const Text("Scan QR Code with a scanner such as your camera.", textAlign: TextAlign.center, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 30)),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(50),
                        child: QrImage(
                          data: 'https://github.com/Allddo',
                          version: QrVersions.auto,
                          size: 340,
                          gapless: false,
                        )
                    )
                  ],
              )
          )
        );
  }
}