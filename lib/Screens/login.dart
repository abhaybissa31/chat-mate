import 'package:chat_app/Screens/singup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool peakPassword = true;
  Widget eyeValue = const Icon(CupertinoIcons.eye_fill);

  _OpenSingupPage(BuildContext context) async {
    print("Login function started");
    Navigator.of(context).pushReplacement(
      // MaterialPageRoute(builder: (BuildContext context)=>const Login())
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const Singupscreen(),
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
        formkey.currentState!.save();
        try {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
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
          padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
          child: Form(
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Log in to ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ChatMate',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
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
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    // Add code for password field (similar to username)
                    // Add code for login button and functionality
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      style: const TextStyle(color: Colors.white),
                      controller: _passwordController,
                      obscureText: peakPassword,
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return "Password must be 6 characters long  ";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredPass = value!;
                      },
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
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  // style:OutlinedButton.styleFrom(backgroundColor: Colors.white,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      // Adjust the radius as needed
                    ),
                  ),
                  onPressed: submit,
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
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
                ElevatedButton(
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
                const SizedBox(
                  height: 8,
                ),
                // const Center(
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    const Text(
                      "Don't have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                        width: 5), // Add spacing between texts if needed
                    GestureDetector(
                      onTap: () {
                        _OpenSingupPage(context);
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),

                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
