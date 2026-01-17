import 'package:flutter/material.dart';

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        '''
Thapar Ventures Cell (TVC) is the official
entrepreneurship cell of TIET.

The Internship Fair connects students
with top startups and companies across India.
        ''',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
