import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

import './Quote.dart';

class QuoteData extends StatefulWidget {
    final FirebaseApp firebaseApp;
  QuoteData(this.firebaseApp);
  @override
  _QuoteDataState createState() => _QuoteDataState();
}

// call the API and fetch the response

class _QuoteDataState extends State<QuoteData>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  DatabaseReference _dbRef;

  Quote quote;
  //var dbHelper;
  List<Quote> wholeQuotes = [];
  @override
  void initState() {
        fetchQuote();
    _dbRef = FirebaseDatabase.instance.reference().child('favourites');
    super.initState();
  }

  fetchQuote() async {
    final response = await http.get('https://type.fit/api/quotes');
    print(response.body);
    if (response.statusCode == 200) {
      final List t = json.decode(response.body);

      wholeQuotes = t.map((e) => Quote.fromJson(e)).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (wholeQuotes.isEmpty) return Center(child: CircularProgressIndicator());

    int random = Random().nextInt(wholeQuotes.length - 1);
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.transparent,
              body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 50.0),
              child: Text(
                wholeQuotes[random].quoteText,
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontFamily: 'quoteScript'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              '-${wholeQuotes[random].quoteAuthor}-',
              style: TextStyle(
                  fontSize: 23.0, color: Colors.white, fontFamily: 'quoteScript'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Share.share(
                        '${wholeQuotes[random].quoteText}--${wholeQuotes[random].quoteAuthor}');
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Quote q = Quote(
                        quoteText: wholeQuotes[random].quoteText,
                        quoteAuthor: wholeQuotes[random].quoteAuthor);
                    _dbRef.push().set(q.toMap());
                    final snackBar = SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        'Added to favorites',
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      fetchQuote();
                    });
                    
                  },
                ),
                
              ],
              
            )
          ],
        ),
      ),
    );
  }
}
