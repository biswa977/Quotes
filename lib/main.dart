import 'package:flutter/material.dart';
import './quote_data.dart';
import './favorite_quotes.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp firebaseApp = null;
  // await Firebase.initializeApp(
  //   name: 'test-c5969',
  //   options: FirebaseOptions(
  //           appId: '1:643198222929:android:4b63d580f1a9b6c1006e70',
  //           apiKey: 'AIzaSyBkslusXO0-MHtuDWp5k9x-TgNaExX26r4',
  //           messagingSenderId: '643198222929',
  //           projectId: 'test-c5969',
  //           databaseURL: 'https://test-c5969.firebaseio.com/',
  //         ),
  // );
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: HomePage(firebaseApp),
        ),
      ),
    );
}
class HomePage extends StatelessWidget {

  HomePage(this.firebaseApp);
  final FirebaseApp firebaseApp;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: size.width / 5,
        backgroundColor: Colors.black,
        title: Text(
          'Quotes',
          style: TextStyle( fontSize: 22.0),
        ),
        bottom: TabBar(
          tabs: <Widget>[
            Tooltip(
              message: 'Daily Quotes',
              child: Tab(
                icon: Icon(
                  Icons.today,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Stack(children: <Widget>[
            Center(
              child: Image.asset(
                'images/background.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
            QuoteData(firebaseApp),
          ]),
          FavoriteQuotes(firebaseApp),
        ],
      ),
    );
  }
}
