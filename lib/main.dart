import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/music.dart';
import 'package:audioplayer2/audioplayer2.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Home(title: 'Music App',),
    );
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<StatefulWidget> createState() => _Home(); 
}

class _Home extends State<Home> {

  List<Music> myMusicList = [
    Music('Music 1', 'CodaBee', 'images/un.jpg', 'https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
    Music('Music 2', 'CodaBee', 'images/deux.jpg', 'https://codabee.com/wp-content/uploads/2018/06/deux.mp3')
  ];

  Music actualMusic;

  AudioPlayer audioPlayer;
  StreamSubscription positionSub;
  StreamSubscription subscriptionState;
  Duration position = Duration(seconds: 0);
  Duration duration = Duration(seconds: 10);
  PlayerState status = PlayerState.stopped;
  int index = 0;

  @override
  void initState() {
    super.initState();
    actualMusic = myMusicList[index];
    audioPlayerConfiguration(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(widget.title),
        centerTitle: true,
        elevation: 15.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Card(
              color: Colors.grey,
              elevation: 15.0,
              child: Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: Image.asset(actualMusic.imagePath),
              ),
            ),
            textStyle(actualMusic.title, 1.5),
            textStyle(actualMusic.artist, 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                button(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                button(status == PlayerState.playing ? Icons.pause : Icons.play_arrow, 45.0, status == PlayerState.playing ? ActionMusic.pause : ActionMusic.play),
                button(Icons.fast_forward, 30.0, ActionMusic.forward),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textStyle(fromDuration(position), 0.8),
                textStyle(fromDuration(duration), 0.8),
              ],
            ),
            Slider(
              value: position.inSeconds.toDouble(), 
              min: 0.00,
              max: 22.0,
              inactiveColor: Colors.white,
              activeColor: Colors.red,
              onChanged: (double d) {
                setState(() {
                  audioPlayer.seek(d);
                });
              }
            )
          ],
        ),
      ),
    );
  }

  Text textStyle(String data, double scale) =>
    Text(
      data, 
      textScaleFactor: scale, 
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic,
        fontSize: 20.0
      ),
    );

  IconButton button(IconData icon, double size, ActionMusic action) =>
    IconButton(
      iconSize: size,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            play();
            break;
          case ActionMusic.pause:
            pause();
            break;
          case ActionMusic.rewind:
            rewind();
            break;
          case ActionMusic.forward:
            forward();
            break;
        }
      },
    );

  void audioPlayerConfiguration() {
    audioPlayer = AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged.listen(
      (pos) => setState(() => position = pos)
    );
    subscriptionState = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          duration = audioPlayer.duration;
        });
      } else if (state == AudioPlayerState.STOPPED) {
          setState(() {
            status = PlayerState.stopped;
          });
      }
    }, onError: (message) {
      print('error: $message');
      setState(() {
        status = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    }
    );
  }

  Future play() async {
    await audioPlayer.play(actualMusic.musicUrl);
    setState(() {
      status = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      status = PlayerState.paused;
    });
  }

  void forward() {
    if (index == myMusicList.length - 1) {
      index = 0;
    } else {
      index++;
    }
    actualMusic = myMusicList[index];
    audioPlayer.stop();
    audioPlayerConfiguration();
    play();
  }

  void rewind() {
    if (position > Duration(seconds: 3)) {
      audioPlayer.seek(0.0);
    } else {
      if (index == 0) {
        index = myMusicList.length - 1;
      } else {
        index--;
      }
      actualMusic = myMusicList[index];
      audioPlayer.stop();
      audioPlayerConfiguration();
      play();
    }    
  }

  String fromDuration(Duration duration) {
    return duration.toString().split('.').first;
  }
}

enum ActionMusic {
  play,
  pause,
  rewind,
  forward
}

enum PlayerState {
  playing,
  stopped,
  paused
}