import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class _ResourcesTab extends StatelessWidget {
  const _ResourcesTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('if_resources').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: snapshot.data!.docs.map((doc) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.link),
                title: Text(doc['title']),
                onTap: () async {
                  final url = Uri.parse(doc['url']);
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
