import 'package:flutter/material.dart';

class MapControlButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocationPressed;

  const MapControlButtons({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'zoomInBtn',
          mini: true,
          backgroundColor: Colors.white,
          onPressed: onZoomIn,
          child: const Icon(Icons.add, color: Colors.black87), // الـ child بقا في الآخر هنا
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'zoomOutBtn',
          mini: true,
          backgroundColor: Colors.white,
          onPressed: onZoomOut,
          child: const Icon(Icons.remove, color: Colors.black87), // الـ child في الآخر هنا
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'myLocationBtn',
          backgroundColor: Colors.white,
          onPressed: onMyLocationPressed,
          child: const Icon(Icons.gps_fixed, color: Color(0xFF0F62AC)), // الـ child في الآخر هنا
        ),
      ],
    );
  }
}