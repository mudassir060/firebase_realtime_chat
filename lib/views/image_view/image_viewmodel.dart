import 'dart:io';
import 'dart:developer';
import 'package:firebase_realtime_chat/services/snak_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver/gallery_saver.dart';

class ImageViewModel extends BaseViewModel {
  Future<void> saveImage(BuildContext context, String imageUrl) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        // Get the image data from the URL
        var response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          // Find the temp directory path
          final Directory tempDir = await getTemporaryDirectory();
          // Create a file in temp directory to save the image
          File file = File('${tempDir.path}/tempImage.jpg');
          await file.writeAsBytes(response.bodyBytes);
          // Save the image to the gallery
          bool success = await GallerySaver.saveImage(file.path) ?? false;
          showErrorSnake(success ? 'Image saved!' : 'Error saving image!');
        } else {
          log('Failed to load image.');
          showErrorSnake('Failed to load image.');
        }
      } catch (e) {
        log('An error occurred while saving the image: $e');
        showErrorSnake('An error occurred while saving the image.');
      }
    } else if (status.isPermanentlyDenied) {
      showErrorSnake(
          'Permission is permanently denied. Please enable it from app settings.');
    } else {
      // openAppSettings();
      await Permission.storage.request();
      showErrorSnake('Permission denied. Cannot save image.');
    }
  }
}
