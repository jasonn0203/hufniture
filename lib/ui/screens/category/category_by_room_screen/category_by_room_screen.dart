import 'package:flutter/material.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class CategoryByRoomScreen extends StatelessWidget {
  const CategoryByRoomScreen({super.key, required this.roomName});
  final String roomName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: roomName), // set room name here
      body: const Center(
        child: Text('data'),
      ),
    );
  }
}
