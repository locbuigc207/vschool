import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_result/simple_result.dart';
import 'package:vschool/commons/api/failures/failures.dart';

abstract class ILocalFileService {
  Future<Result<File, Failure>> saveFile({
    required String data,
    required String fileName,
    String? fileExtension,
    String? directory,
  });
}

class LocalFileService implements ILocalFileService {
  @override
  Future<Result<File, Failure>> saveFile({
    required String data,
    required String fileName,
    String? fileExtension,
    String? directory,
  }) async {
    print(
        'LocalFileService - Starting saveFile with fileName: $fileName, Platform: ${Platform.operatingSystem}');

    try {
      List<int> imageBytes = base64Decode(data);
      print('LocalFileService - Decoded image bytes: ${imageBytes.length}');

      if (Platform.isIOS) {
        // For iOS, use a more robust approach
        return await _saveToIOSGallery(imageBytes, fileName);
      } else {
        // For Android, use gal
        return await _saveToAndroidGallery(imageBytes, fileName);
      }
    } on Exception catch (e) {
      print('LocalFileService - Exception occurred: $e');
      return Result.failure(UnknownFailure(message: 'Lỗi khi lưu file: $e'));
    }
  }

  Future<Result<File, Failure>> _saveToAndroidGallery(
      List<int> imageBytes, String fileName) async {
    try {
      // Check if gal has permission
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        print('LocalFileService - Requesting gal permission');
        hasAccess = await Gal.requestAccess();
      }

      if (!hasAccess) {
        print('LocalFileService - Gal permission denied');
        return const Result.failure(
            PermissionFailure(message: 'Không có quyền truy cập thư viện ảnh'));
      }

      // Use gal to save to gallery
      await Gal.putImageBytes(
        Uint8List.fromList(imageBytes),
        name: fileName,
      );

      print('LocalFileService - Image saved to Android gallery successfully');
      // Create a temporary file object for compatibility
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName.jpg');
      await tempFile.writeAsBytes(imageBytes);
      return Result.success(tempFile);
    } catch (e) {
      print('LocalFileService - Android gallery save failed: $e');
      return Result.failure(UnknownFailure(
          message: 'Không thể lưu ảnh vào thư viện Android: $e'));
    }
  }

  Future<Result<File, Failure>> _saveToIOSGallery(
      List<int> imageBytes, String fileName) async {
    try {
      // For iOS, first try gal
      try {
        bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          print('LocalFileService - Requesting iOS gal permission');
          hasAccess = await Gal.requestAccess();
        }

        if (hasAccess) {
          await Gal.putImageBytes(
            Uint8List.fromList(imageBytes),
            name: fileName,
          );
          print(
              'LocalFileService - Image saved to iOS gallery via gal successfully');
        } else {
          throw Exception('Gal permission denied');
        }
      } catch (galError) {
        print(
            'LocalFileService - Gal failed on iOS, trying fallback: $galError');
        // Fallback: save to Documents directory and let user manually save
        return await _saveToIOSDocuments(imageBytes, fileName);
      }

      // Create a temporary file object for compatibility
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName.jpg');
      await tempFile.writeAsBytes(imageBytes);
      return Result.success(tempFile);
    } catch (e) {
      print('LocalFileService - iOS gallery save failed: $e');
      return Result.failure(
          UnknownFailure(message: 'Không thể lưu ảnh vào thư viện iOS: $e'));
    }
  }

  Future<Result<File, Failure>> _saveToIOSDocuments(
      List<int> imageBytes, String fileName) async {
    try {
      // Save to Documents directory as fallback
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName.jpg';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      print('LocalFileService - Image saved to iOS Documents: $filePath');
      return Result.success(file);
    } catch (e) {
      print('LocalFileService - iOS Documents save failed: $e');
      return Result.failure(
          UnknownFailure(message: 'Không thể lưu ảnh vào Documents: $e'));
    }
  }
}
