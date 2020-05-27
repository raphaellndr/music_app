import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'Music App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home(); 
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('Music App'),
        centerTitle: true,
        elevation: 15.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Card(
              color: Colors.grey,
              elevation: 15.0,
              child: Container(
                width: MediaQuery.of(context).size.width /1.7,
                height: MediaQuery.of(context).size.width /1.7,
                child: Image.asset(
                  'images/un.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Music 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Artist',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.fast_rewind,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  onPressed: rewind                
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  onPressed: rewind                
                ),
                IconButton(
                  icon: Icon(
                    Icons.fast_forward,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  onPressed: rewind                
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void play() {
    return null;
  }

  void rewind() {
    return null;
  }

  void forward() {
    return null;
  }
}