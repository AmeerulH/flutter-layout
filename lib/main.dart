import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:convert';

// Future<Data> fetchData() async {
//   final response = await http.get(Uri.parse(
//       'https://drive.google.com/file/d/1k8QyDzN7G60K99kelCRLge9j80hTK09X/view'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Data.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

// class Data {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String username;
//   final String lastSeenTime;
//   final String avatar;
//   final String status;

//   Data({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.username,
//     required this.lastSeenTime,
//     required this.avatar,
//     required this.status,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['id'],
//       firstName: json['first-name'],
//       lastName: json['last-name'],
//       username: json['username'],
//       lastSeenTime: json['last-seen-time'],
//       avatar: json['avatar'],
//       status: json['status'],
//     );
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List items = [];

  // Future<void> getJson() async {
  //   final String response =
  //       await rootBundle.loadString('MOCK_DATA for Flutter layouting.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     items = data;
  //   });
  //   // ignore: avoid_print
  //   // items.forEach((value) => {print('$value \n')});
  // }

  var _scrollController = ScrollController();
  var _list = 20;

  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          setState(() {
            _list += 10;
          });
          // print("reach end " + _listCap.toString());
        }
      }
    });
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            var items = json.decode(snapshot.data.toString());
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        //
                        color: Colors.black,
                        width: 3.0,
                      ),
                      top: BorderSide(
                        //
                        color: Colors.black,
                        width: 3.0,
                      ),
                    ),
                    color: Colors.amberAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: items[index].containsKey('avatar')
                                ? NetworkImage(items[index]['avatar'])
                                : const NetworkImage(
                                    'https://static.thenounproject.com/png/3134331-200.png'),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${items[index]['first_name']} ${items[index]['last_name']}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        items[index]['username'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          items[index].containsKey('status')
                                              ? items[index]['status']
                                              : "N/A",
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              )),
                        ])),
                        Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(items[index]['last_seen_time'],
                                    style: const TextStyle(color: Colors.grey)),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Text(items[index].containsKey('messages')
                                    ? items[index]['messages'].toString()
                                    : '0'),
                              )
                            ]))
                      ],
                    ),
                  ),
                );
              },
              itemCount: _list,
            );
          },
          future: DefaultAssetBundle.of(context).loadString('data.json'),
        ),
      ),
    );
  }
}
