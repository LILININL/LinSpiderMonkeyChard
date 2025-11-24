import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String? userName;
  final String? businessName;

  const UserInfoCard({super.key, this.userName, this.businessName});

  @override
  Widget build(BuildContext context) {
    if (userName == null && businessName == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          if (businessName != null)
            Text(
              businessName!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          if (userName != null)
            Text(
              'User: $userName',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
        ],
      ),
    );
  }
}
