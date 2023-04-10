import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Expanded(
              child: _Logo(),
            ),
            Expanded(
              child: _Image(),
            ),
            Expanded(
              child: _Button(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.orange[300]!,
              blurRadius: 12,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.videocam,
                size: 40.0,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  letterSpacing: 8.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'asset/img/home_img.png',
      ),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button();

  @override
  State<_Button> createState() => __ButtonState();
}

class __ButtonState extends State<_Button> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('입장하기'),
        ),
      ],
    );
  }
}
