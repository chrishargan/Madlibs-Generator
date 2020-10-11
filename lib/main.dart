import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:random_words/random_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madlibs Generator',
      home: new RandomSentences(),
    );
  }
}

class RandomSentences extends StatefulWidget {
  @override
  createState() => new _RandomSentencesState();
}

class _RandomSentencesState extends State<RandomSentences> {
  final _sentences = <String>[];
  final _biggerFont = const TextStyle(fontSize: 14.0);
  final _favourites = new Set<String>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Madlibs Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: _pushFavourites,
          )
        ],
      ),
      body: _buildSentences(),
    );
  }

  void _pushFavourites() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _favourites.map(
            (sentence) {
              return new ListTile(
                title: new Text(
                  sentence,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('My Favourite Madlibs'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  String _getSentence() {
    final noun = new WordNoun.random();
    final adjective = new WordAdjective.random();
    return 'The Developer created a ${adjective.asCapitalized} App and tested it on their ${noun.asCapitalized}';
  }

  Widget _buildRow(String sentence) {
    final alreadyFound = _favourites.contains(sentence);
    return new ListTile(
        title: new Text(
          sentence,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadyFound ? Icons.thumb_up : Icons.thumb_down,
          color: alreadyFound ? Colors.green : null,
        ),
        onTap: () {
          setState(() {
            if (alreadyFound) {
              _favourites.remove(sentence);
            } else {
              _favourites.add(sentence);
            }
          });
        });
  }

  Widget _buildSentences() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _sentences.length) {
          for (int x = 0; x < 10; x++) {
            _sentences.add(_getSentence());
          }
        }
        return _buildRow(_sentences[index]);
      },
    );
  }
}
