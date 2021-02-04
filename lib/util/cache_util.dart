import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
class CacheUtil {

  static CacheUtil _instance;

  static CacheUtil getInstance(){
    if(_instance == null)
      _instance = CacheUtil();
    return _instance;
  }

  void clearCache({Function onComplete, bool isDeleteImage = false}) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      await deleteDir(tempDir);
      await DefaultCacheManager().emptyCache();
    } finally {
      if (onComplete != null) onComplete('0.00B');
    }
  }

  Future<String> loadCache(Function onComplete) async {
    Directory tempDir = await getTemporaryDirectory();
    String size = _renderSize(await _getTotalSizeOfFilesInDir(tempDir)).toString();
    onComplete(size);
    return size;
  }

  dynamic _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  static Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  ///递归方式删除目录
  Future<Null> deleteDir(FileSystemEntity file, {bool isDeleteImage = false}) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await deleteDir(child, isDeleteImage: isDeleteImage);
        }
      }else if(file is File){
        if(isDeleteImage){
          await file.delete();
        }else{
          if(!(file.path.contains(".jpg")||file.path.contains(".png")||file.path.contains(".webp"))){
            await file.delete();
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
