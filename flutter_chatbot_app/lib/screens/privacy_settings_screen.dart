import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class PrivacySettingsScreen extends StatefulWidget {
  @override
  _PrivacySettingsScreenState createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _cameraAccess = false;
  bool _galleryAccess = false;
  bool _videoAccess = false;

  Future<void> _handlePermissionToggle({
    required bool currentValue,
    required Permission permission,
    required void Function(bool) updateState,
  }) async {
    if (!currentValue) {
      final status = await permission.status;

      if (status.isPermanentlyDenied) {
        await _showSettingsDialog();
        return;
      }

      final newStatus = await permission.request();
      if (newStatus.isGranted) {
        updateState(true);
      } else if (newStatus.isPermanentlyDenied) {
        await _showSettingsDialog();
      } else {
        updateState(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission denied")),
        );
      }
    } else {
      // Toggle off — can't revoke permissions manually
      final opened = await openAppSettings();
      if (!opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unable to open app settings")),
        );
      }
    }
  }

  Future<void> _showSettingsDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Permission Required"),
        content: Text("Permission has been permanently denied. Please enable it manually in settings."),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text("Open Settings"),
            onPressed: () {
              openAppSettings();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      appBar: AppBar(
        title: Text(
          "Privacy Settings",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Color(0xFFFFD700),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: Text("Camera Access", style: GoogleFonts.poppins(fontSize: 16)),
            subtitle: Text("Allow access to camera"),
            value: _cameraAccess,
            onChanged: (_) {
              _handlePermissionToggle(
                currentValue: _cameraAccess,
                permission: Permission.camera,
                updateState: (val) => setState(() => _cameraAccess = val),
              );
            },
          ),
          SwitchListTile(
            title: Text("Gallery Access", style: GoogleFonts.poppins(fontSize: 16)),
            subtitle: Text("Allow access to gallery/photos"),
            value: _galleryAccess,
            onChanged: (_) {
              _handlePermissionToggle(
                currentValue: _galleryAccess,
                permission: Permission.photos, // Maps to READ_MEDIA_IMAGES
                updateState: (val) => setState(() => _galleryAccess = val),
              );
            },
          ),
          SwitchListTile(
            title: Text("Video Access", style: GoogleFonts.poppins(fontSize: 16)),
            subtitle: Text("Allow access to video files"),
            value: _videoAccess,
            onChanged: (_) {
              _handlePermissionToggle(
                currentValue: _videoAccess,
                permission: Permission.videos, // Maps to READ_MEDIA_VIDEO
                updateState: (val) => setState(() => _videoAccess = val),
              );
            },
          ),
        ],
      ),
    );
  }
}
