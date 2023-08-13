import 'package:flutter/material.dart';
import 'package:flutter_sqflite/database_handler.dart';
import 'package:flutter_sqflite/notes_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHandler? dbHandler = DatabaseHandler();
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    loadNotesData();
    super.initState();
  }

  loadNotesData() async {
    notesList = dbHandler!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes SQL"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (BuildContext context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey<int>(snapshot.data![index].id!),
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction) async {
                              await dbHandler!.delete(snapshot.data![index].id!);

                              setState(() {
                                notesList = dbHandler!.getNotesList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            background: Container(
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete_forever),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(snapshot.data![index].description),
                                trailing: Text(snapshot.data![index].age.toString()),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Shimmer.fromColors(
                      baseColor: Colors.black26,
                      highlightColor: Colors.black26,
                      child: ListTile(
                        title: Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.black26,
                        ),
                        subtitle: Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.black26,
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHandler!
              .insert(NotesModel(
            title: "Third Note",
            age: 22,
            description: "This is third SQFLite note",
            email: "sonia@gmail.com",
          ))
              .then((value) {
            setState(() {
              notesList = dbHandler!.getNotesList();
            });
          }).onError((error, stackTrace) {
            debugPrintStack(stackTrace: stackTrace);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
