class ToDo {
  final String id;
  final String todoText;
  final DateTime? dueDate; // Tanggal dan waktu
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.dueDate,
    this.isDone = false,
  });

  // Convert ToDo object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'todoText': todoText,
        'dueDate': dueDate?.toIso8601String(), // Simpan sebagai ISO8601 String
        'isDone': isDone,
      };

  // Convert JSON to ToDo object
  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
        id: json['id'],
        todoText: json['todoText'],
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        isDone: json['isDone'],
      );

  static todosList() {}
}
