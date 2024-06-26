class DirectoryInfo {
  final String path;
  final int fileCount;
  final int folderCount;

  DirectoryInfo({
    required this.path,
    required this.fileCount,
    required this.folderCount,
  });

  @override
  String toString() {
    return 'DirectoryInfo(path: $path, files: $fileCount, directories: $folderCount)';
  }
}
