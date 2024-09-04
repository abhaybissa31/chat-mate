import 'package:flutter/material.dart';

class MainForm extends StatelessWidget {
  const MainForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF5D0D88)),
        child: Column(
          children: [
            Expanded(
              flex: 13,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(90)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(29.0),
                  child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return Text("hello" + (index + 1).toString());
                      }),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: const Center(
                      child: Text(
                    "lavina",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
            ),
          ],
        ),
      ),
    );
  }
}
