import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/cards.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<String> _filters = ['All', 'Workshops', 'Competitions', 'Keynotes', 'Expo'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: AppColors.darkContrast,
                    selectedColor: AppColors.brandBlue.withOpacity(0.2),
                    checkmarkColor: AppColors.brandBlue,
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: isSelected ? AppColors.brandBlue : AppColors.supportBlue,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.brandBlue : AppColors.supportBlue.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Event List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: EventCard(
                    title: 'Innovation in the Age of AI',
                    date: 'March 15, 10:00 AM',
                    location: 'Main Auditorium',
                    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop',
                    onTap: () {
                      Navigator.pushNamed(context, '/event_detail');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
