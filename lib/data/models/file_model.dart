class FileModel {
  final int? id;
  final int directoryId;
  final String path;

  FileModel({
    this.id,
    required this.directoryId,
    required this.path,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'directoryId': directoryId,
      'path': path,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
      path: map['name'],
      directoryId: map['directoryId'],
    );
  }
}
