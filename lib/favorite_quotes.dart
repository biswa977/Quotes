import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:motivation_on_the_go/main.dart';

import './Quote.dart';


class FavoriteQuotes extends StatefulWidget {
    final FirebaseApp firebaseApp;
  FavoriteQuotes(this.firebaseApp);

  @override
  _FavoriteQuotesState createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  Future<List<Quote>> wholeQuotes;
 
  StreamSubscription<Event> _favSubscription;
  DatabaseReference _dbRef;

  List<Quote> _quotes = [];
  List<String> keys = [];

  void initState() {
    super.initState();
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase.instance;//(app: widget.firebaseApp);
    _dbRef = database.reference().child('favourites');
    _dbRef.once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
      print(Map.from(snapshot.value));
      (Map.from(snapshot.value)).forEach((k,v) {
        _quotes.add(Quote.fromJson(Map.from(v)));
        keys.add(k);
      });
      setState(() {
        
      });
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _dbRef.keepSynced(true);
    _favSubscription = _dbRef.onValue.listen((Event event) {
      print(event.snapshot.value);
      setState(() {
        
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if(_quotes.isEmpty)return Center(
                child: Text(
                  'No Data in the Favorites',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'quoteScript'),
                ),
              );
              return ListView.builder(
                  itemCount: _quotes.length,
                  itemBuilder: (builder, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          _quotes[index].quoteText,
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: 'quoteScript'),
                        ),
                        subtitle: Text(
                          _quotes[index].quoteAuthor,
                          style: TextStyle(
                              fontSize: 17.0, fontFamily: 'quoteScript'),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.red,
                            onPressed: () async{
                              await _dbRef.child(keys[index]).remove();
                              _quotes.removeAt(index);
                              keys.removeAt(index);
                              setState(() {
                                
                              });
                              final removedSnackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  'Removed from Favorites',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              );
                              Scaffold.of(context)
                                  .showSnackBar(removedSnackBar);
                            }),
                      ),
                    );
                  });
              
            
  }
}
