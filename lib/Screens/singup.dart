import 'package:chat_app/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class Singupscreen extends StatefulWidget {
  const Singupscreen({super.key});
  @override
  State<Singupscreen> createState() => _SingupscreenState();
}

class _SingupscreenState extends State<Singupscreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool peakPassword = true;
  Widget eyeValue = const Icon(CupertinoIcons.eye_fill);

  _OpenSingupPage(BuildContext context) async {
    print("Login function started");
    Navigator.of(context).pushReplacement(
      // MaterialPageRoute(builder: (BuildContext context)=>const Login())
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Login(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    var enteredEmail = '';
    var enteredPass = '';

    void submit() async {
      final isValidated = formkey.currentState!.validate();

      if (isValidated) {
        var _errormsg;
        formkey.currentState!.save();
        try {
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
                  email: enteredEmail, password: enteredPass);
          print(userCredentials);
        } on FirebaseAuthException catch (error) {
          ScaffoldMessenger.of(context).clearMaterialBanners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message ?? 'Authentication failed'),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Let\u0027s get',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' Started',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: const Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                          left: BorderSide(color: Colors.grey)),
                      borderRadius: BorderRadius.circular(19)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align items vertically centered
                        children: [
                          // Column for Image (Avatar + Icon)
                          Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center image vertically
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: const CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.black,
                                  // Adjust the size of the CircleAvatar if necessary
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ), // Image (Avatar)
                              const Row(
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.white,
                                    size: 20,
                                    textDirection: TextDirection.ltr,
                                    applyTextScaling: true,
                                  ),
                                  Text(
                                    "Add picture",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                              width: 40), // Space between image and text fields

                          // Flexible Column for TextFields
                          Flexible(
                            flex:
                                3, // Adjust the ratio of space the TextFields take (e.g., 3/4)
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      controller: _usernameController,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !value.contains('@')) {
                                          return "Please enter a valid email address";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        enteredEmail = value!;
                                      },
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your email',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Password",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      controller: _passwordController,
                                      obscureText: peakPassword,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length < 6) {
                                          return "Password must be 6 characters long  ";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        enteredPass = value!;
                                      },
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Password',
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              peakPassword = !peakPassword;
                                            });
                                          },
                                          // Display the current eye icon based on peakPassword
                                          child: Icon(
                                            peakPassword
                                                ? CupertinoIcons
                                                    .eye_fill // Show icon when password is visible
                                                : CupertinoIcons
                                                    .eye_slash_fill, // Hide icon when password is hidden
                                          ),
                                        ),
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      ElevatedButton(
                        // style:OutlinedButton.styleFrom(backgroundColor: Colors.white,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          // foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                            // Adjust the radius as needed
                          ),
                        ),
                        onPressed: submit,
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Colors.grey,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Image.asset(
                            "lib/assets/images/google.png",
                            width: 20,
                            height: 20,
                          ),
                        ),

                        // Add spacing between the icon and text
                        const Expanded(
                          // child: Center(
                          child: Text(
                            "Continue with Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    const Text(
                      "Already have an Account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        _OpenSingupPage(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // body:
    );
  }
}
