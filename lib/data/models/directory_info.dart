class DirectoryInfo {
  final String path;
  final int fileCount;
  final int folderCount;
  final bool isFavorite;
  final String? name;

  const DirectoryInfo({
    required this.path,
    required this.fileCount,
    required this.folderCount,
    this.isFavorite = false,
    this.name,
  });

  @override
  String toString() {
    return 'DirectoryInfo(path: $path, files: $fileCount, directories: $folderCount, name: $name)';
  }

  DirectoryInfo copyWith({
    String? path,
    int? fileCount,
    int? folderCount,
    bool? isFavorite,
    String? name,
  }) {
    return DirectoryInfo(
      path: path ?? this.path,
      fileCount: fileCount ?? this.fileCount,
      folderCount: folderCount ?? this.folderCount,
      isFavorite: isFavorite ?? this.isFavorite,
      name: name ?? this.name,
    );
  }
}
