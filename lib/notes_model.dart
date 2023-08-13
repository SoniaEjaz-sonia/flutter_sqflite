class NotesModel {
  final int? id;
  final String title;
  final int age;
  final String description;
  final String email;

  NotesModel({
    this.id,
    required this.title,
    required this.age,
    required this.description,
    required this.email,
  });

  NotesModel.fromMap(Map<String, dynamic> results)
      : id = results['id'],
        title = results['title'],
        age = results['age'],
        description = results['description'],
        email = results['email'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'age': age,
      'description': description,
      'email': email,
    };
  }
}
