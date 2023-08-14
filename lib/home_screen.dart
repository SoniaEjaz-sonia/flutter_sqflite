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
                          return InkWell(
                            onTap: () {},
                            child: Dismissible(
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
                                child: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                              ),
                              child: Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  title: Text(snapshot.data![index].title),
                                  subtitle: Text(snapshot.data![index].description),
                                  trailing: IconButton(
                                      onPressed: () {
                                        TextEditingController nameController =
                                            TextEditingController(text: snapshot.data![index].title);
                                        TextEditingController descController =
                                            TextEditingController(text: snapshot.data![index].description);

                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Add Note"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextFormField(
                                                      controller: nameController,
                                                      decoration: const InputDecoration(labelText: "Name"),
                                                    ),
                                                    const SizedBox(height: 30),
                                                    TextFormField(
                                                      controller: descController,
                                                      decoration:
                                                          const InputDecoration(labelText: "Description"),
                                                    ),
                                                  ],
                                                ),
                                                actionsAlignment: MainAxisAlignment.center,
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.redAccent,
                                                      minimumSize: const Size(100, 40),
                                                    ),
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.deepPurpleAccent,
                                                      minimumSize: const Size(100, 40),
                                                    ),
                                                    onPressed: () {
                                                      dbHandler!
                                                          .update(
                                                            NotesModel(
                                                              id: snapshot.data![index].id!,
                                                              title: nameController.text,
                                                              age: 22,
                                                              description: descController.text,
                                                              email: "sonia@gmail.com",
                                                            ),
                                                          )
                                                          .then((value) => setState(() {
                                                                notesList = dbHandler!.getNotesList();
                                                              }))
                                                          .onError((error, stackTrace) =>
                                                              debugPrintStack(stackTrace: stackTrace));

                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Add",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.edit_note,
                                      )),
                                ),
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
          TextEditingController nameController = TextEditingController();
          TextEditingController descController = TextEditingController();

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Note"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Name"),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(labelText: "Description"),
                      ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed: () {
                        dbHandler!
                            .insert(NotesModel(
                          title: nameController.text,
                          age: 22,
                          description: descController.text,
                          email: "sonia@gmail.com",
                        ))
                            .then((value) {
                          setState(() {
                            notesList = dbHandler!.getNotesList();
                          });
                        }).onError((error, stackTrace) {
                          debugPrintStack(stackTrace: stackTrace);
                        });

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
