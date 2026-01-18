import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/services/ticket_service.dart';
import '../widgets/cards.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: TicketService().getUserTickets(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading tickets', style: AppTypography.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final tickets = snapshot.data?.docs ?? [];

          // Empty state
          if (tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 80,
                    color: AppColors.supportBlue.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text('No tickets yet', style: AppTypography.heading3),
                  const SizedBox(height: 8),
                  Text(
                    'Your purchased tickets will appear here',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Create a demo ticket for testing
                      try {
                        await TicketService().createDemoTicket(
                          eventName: "E-SUMMIT'26 Full Access",
                          ticketType: 'General',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Demo ticket created!'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Demo Ticket'),
                  ),
                ],
              ),
            );
          }

          // Tickets list
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index].data();
              final ticketId = ticket['ticketId'] ?? tickets[index].id;
              final eventName = ticket['eventName'] ?? 'E-SUMMIT\'26';
              final ticketType = ticket['ticketType'] ?? 'General';
              final createdAt = ticket['createdAt'] as Timestamp?;
              final used = ticket['used'] == true;

              String dateStr = 'March 15-17, 2026';
              if (createdAt != null) {
                final date = createdAt.toDate();
                dateStr = '${date.day}/${date.month}/${date.year}';
              }

              return Stack(
                children: [
                  TicketCard(
                    eventName: eventName,
                    ticketType: ticketType,
                    ticketId: ticketId,
                    date: dateStr,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/ticket_detail',
                        arguments: {
                          'ticketId': ticketId,
                          'eventName': eventName,
                          'ticketType': ticketType,
                          'date': dateStr,
                          'used': used,
                          'docId': tickets[index].id,
                        },
                      );
                    },
                  ),
                  // Used indicator
                  if (used)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'USED',
                          style: AppTypography.monoSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
