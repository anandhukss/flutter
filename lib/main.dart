import 'package:flutter/material.dart';
import 'package:test_sqli/helper/dbhelper.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = TextEditingController();
  var future = DatabaseHlper.instance.queryAll();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          child: Text("ADD"),
          onPressed: () async {
            int i =
                await DatabaseHlper.instance.insert({"name": controller.text});
            print(i);
            setState(() {
              future = DatabaseHlper.instance.queryAll();
            });
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Enter somethig"),
                  controller: controller,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                width: 200,
                height: 300,
                decoration: BoxDecoration(border: Border.all()),
                child: FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: 2,
                            );
                          },
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(snapshot.data[index]['name']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await DatabaseHlper.instance
                                    .delete(snapshot.data[index]['id']);
                                setState(() {
                                  future = DatabaseHlper.instance.queryAll();
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
