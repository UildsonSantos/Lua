class DirectoryModel {
  final int? id;
  final String path;
  final int folderCount;
  final int fileCount;

  DirectoryModel({
    this.id,
    required this.path,
    required this.folderCount,
    required this.fileCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'folderCount': folderCount,
      'fileCount': fileCount,
    };
  }

  factory DirectoryModel.fromMap(Map<String, dynamic> map) {
    return DirectoryModel(
      id: map['id'],
      path: map['path'],
      folderCount: map['folderCount'],
      fileCount: map['fileCount'],
    );
  }

    @override
  String toString() {
    return 'DirectoryModel(path: $path, files: $fileCount, directories: $folderCount)';
  }
}
