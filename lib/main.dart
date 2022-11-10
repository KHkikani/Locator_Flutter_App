import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List permissionList = [Permission.values];

  Future<String> permissionStatus({required Permission data}) async {
    PermissionStatus status = await data.status;
    return status.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Permission"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: SingleChildScrollView(
                      child: Column(
                        children: Permission.values.map((e) {
                          // var res = await e.status;
                          return ListTile(
                            title: Text(e.toString().split(".")[1]),
                            subtitle: FutureBuilder(
                              future: permissionStatus(data: e),
                              builder: (context, data) {
                                if (data.hasData) {
                                  return Text("${data.data}");
                                } else {
                                  return const Text("Status not found");
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.list)),
          IconButton(
              onPressed: () {
                openAppSettings();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...Permission.values
                  .map(
                    (e) => ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(e.toString().split(".")[1]),
                              content: FutureBuilder(
                                future: permissionStatus(data: e),
                                builder: (context, data) {
                                  return Text("Status = ${data.data}");
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.red,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await e.request();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.green,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text(
                                      "Request",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        // var res = await Permission.bluetooth.request();

                        // print("--------------------------------");
                        // print("Location - $res");
                        // print("--------------------------------");
                        // print(e.toString().split(".")[1]);
                      },
                      child: Text(e.toString().split(".")[1]),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
