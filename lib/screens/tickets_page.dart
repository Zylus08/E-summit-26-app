import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/cards.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
        itemBuilder: (context, index) {
          return TicketCard(
            eventName: 'E-SUMMIT\'26 Full Access',
            ticketType: 'General',
            ticketId: 'ES26-8842-9931',
            date: 'March 15-17, 2026',
            onTap: () {
              Navigator.pushNamed(context, '/ticket_detail');
            },
          );
        },
      ),
    );
  }
}
