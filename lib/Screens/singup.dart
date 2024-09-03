import 'dart:io';

import 'package:chat_app/Screens/chatlist.dart';
import 'package:chat_app/Screens/login.dart';
import 'package:chat_app/widget/pagechange.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';

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
  final formkey = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredPass = '';

  void submit() async {
    final isValidated = formkey.currentState!.validate();

    if (isValidated) {
      formkey.currentState!.save();

      try {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPass,
        );
        print(userCredentials);

        ScaffoldMessenger.of(context).clearMaterialBanners();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black,
            content: Row(
              children: [
                Text("Signed up Successfully. Welcome to "),
                Text(
                  "ChatMate",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        );

        // Redirect to Chatlist after successful signup
        PageChange.changeScreen(context, const Chatlist());
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearMaterialBanners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            content: Text(error.message ?? 'Failed to create account'),
          ),
        );
      } catch (e) {
        // Handle any other unexpected errors
        print('Unexpected error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black,
            content: Text('An unexpected error occurred. Please try again.'),
          ),
        );
      }
    }
  }

  File? _pickedImageFile;

  @override
  Widget build(BuildContext context) {
    // _takePicture(bool isCameraSelected) async {
    //   final imagePicker = ImagePicker();
    //   if (isCameraSelected) {
    //     final pickedImage = await imagePicker.pickImage(
    //       source: ImageSource.camera,
    //       imageQuality: 100,
    //       maxWidth: 600,
    //     );
    //     ScaffoldMessenger.of(context).clearSnackBars();
    //     if (pickedImage == null) {
    //       return;
    //     }

    //     setState(() {
    //       _selectedImage = File(pickedImage.path);
    //     });

    //     widget.onPickImage(_selectedImage!);
    //   } else {
    //     final pickedImage = await imagePicker.pickImage(
    //       source: ImageSource.gallery,
    //       imageQuality: 100,
    //       maxWidth: 600,
    //     );
    //     ScaffoldMessenger.of(context).clearSnackBars();
    //     if (pickedImage == null) {
    //       return;
    //     }

    //     setState(() {
    //       _selectedImage = File(pickedImage.path);
    //     });

    //     widget.onPickImage(_selectedImage!);
    //   }
    // }

    void _pickimage(String pickertype) async {
      final pickedImage = await ImagePickerAndroid().pickImage(
        source:
            pickertype == "Gallery" ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 70,
        maxWidth: 150,
      );

      if (pickedImage != null) {
        setState(() {
          _pickedImageFile = File(pickedImage.path);
        });
        print("Image selected: ${pickedImage.path}");
        // if (_pickedImageFile != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        // }
      } else {
        print("No image selected");
      }
    }

    void _chooseImagePickerSource() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          key: const Key("snackbar"),
          closeIconColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 18, 18, 18),
          duration: const Duration(seconds: 120),
          content: Column(
            children: [
              const Row(
                children: [
                  Text(
                    'Choose a picker:',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    splashFactory: InkSparkle.splashFactory,
                    onTap: () => _pickimage("Camera"),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // InkWell(
                        // onTap:() => _takePicture(true) ,
                        Column(
                          children: [
                            Icon(
                              CupertinoIcons.camera,
                              color: Colors.white,
                              // onPressed: ,
                            ),
                            Text(
                              'Click a picture',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  InkWell(
                    splashFactory: InkSparkle.splashFactory,
                    enableFeedback: true,
                    onTap: () => _pickimage("Gallery"),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Icon(
                              CupertinoIcons.photo_on_rectangle,
                              // onPressed:,
                              color: Colors.white,
                            ),
                            Text(
                              'Choose from Gallery',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
      // }
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
                      ' Let\u0027s get you',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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
                    Text(
                      "🚀",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(19)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Align items vertically centered
                        children: [
                          // Column for Image (Avatar + Icon)
                          Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center image vertically
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  // backgroundColor: Colors.black,
                                  foregroundImage: _pickedImageFile != null
                                      ? FileImage(_pickedImageFile!)
                                      : null,
                                  child: _pickedImageFile == null
                                      ? const Icon(Icons.person,
                                          size: 50, color: Colors.white)
                                      : null,
                                  // Adjust the size of the CircleAvatar if necessary
                                ),
                              ),
                              TextButton.icon(
                                // style: const ButtonStyle(),
                                onPressed: () => _chooseImagePickerSource(),
                                icon: const Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Add Image",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                              width: 15), // Space between image and text fields

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
                        height: 15,
                      ),
                      ElevatedButton(
                        // style:OutlinedButton.styleFrom(backgroundColor: Colors.white,),
                        style: ElevatedButton.styleFrom(
                          // fixedSize: Size(350, 25),
                          backgroundColor: Colors.white,
                          // foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            // Adjust the radius as needed
                          ),
                        ),
                        onPressed: submit,
                        child: const Center(
                          child: Text(
                            "Signup",
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
                        PageChange.changeScreen(context, const Login());
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
