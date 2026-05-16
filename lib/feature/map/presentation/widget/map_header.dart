import 'package:flutter/material.dart';

class MapHeader extends StatelessWidget {
  final String userName;
  final int activeOrdersCount;

  const MapHeader({
    super.key,
    required this.userName,
    required this.activeOrdersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F62AC), Color(0xFF1D83D4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لغة عربية طبقاً للتصميم
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                onPressed: () {},
              ),
              Row(
                children: [
                  const Text(
                    'وصلني شكراً',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'مرحباً، $userName',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            'طلباتك النشطة: $activeOrdersCount',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}