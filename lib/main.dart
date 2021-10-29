import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

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
  List items = [];

  Future<void> getJson() async {
    final String response =
        await rootBundle.loadString('MOCK_DATA for Flutter layouting.json');
    final data = await json.decode(response);
    setState(() {
      items = data;
    });
    // ignore: avoid_print
    // items.forEach((value) => {print('$value \n')});
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
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Load Data'),
              onPressed: getJson,
            ),

            // Display the data loaded from sample.json
            items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    backgroundImage: items[index]
                                            .containsKey('avatar')
                                        ? NetworkImage(items[index]['avatar'])
                                        : const NetworkImage(
                                            'https://static.thenounproject.com/png/3134331-200.png'),
                                  ),
                                ),
                                Container(
                                    child: Column(
                                  children: [
                                    Text(
                                      '${items[index]['first_name']} ${items[index]['last_name']}',
                                    ),
                                    Text(
                                      items[index]['username'],
                                    ),
                                    Text(
                                        items[index].containsKey('status')
                                            ? items[index]['status']
                                            : "N/A",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 10)),
                                  ],
                                )),
                                Container(
                                    child: Column(children: [
                                  Text(items[index]['last_seen_time']),
                                  CircleAvatar(
                                    child: Text(items[index]
                                            .containsKey('messages')
                                        ? items[index]['messages'].toString()
                                        : '0'),
                                  )
                                ]))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
