class FileModel {
  final int id;
  final int directoryId;
  final String path;

  FileModel({
    required this.id,
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
}
