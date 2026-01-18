import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketService {
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Get user's tickets as a real-time stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserTickets() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('tickets')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get a specific ticket by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getTicket(String ticketId) {
    return _db.collection('tickets').doc(ticketId).get();
  }

  /// Generate QR data for a ticket
  String generateQRData(String ticketId, String eventName) {
    final user = _auth.currentUser;
    final uid = user?.uid ?? 'anonymous';
    // QR data format: ESUMMIT26|ticketId|uid|eventName
    return 'ESUMMIT26|$ticketId|$uid|$eventName';
  }

  /// Validate a ticket (for scanning at venue)
  Future<Map<String, dynamic>?> validateTicket(String qrData) async {
    try {
      final parts = qrData.split('|');
      if (parts.length != 4 || parts[0] != 'ESUMMIT26') {
        return {'valid': false, 'error': 'Invalid QR format'};
      }

      final ticketId = parts[1];
      final uid = parts[2];
      final eventName = parts[3];

      final ticketDoc = await _db.collection('tickets').doc(ticketId).get();
      
      if (!ticketDoc.exists) {
        return {'valid': false, 'error': 'Ticket not found'};
      }

      final ticketData = ticketDoc.data()!;
      
      if (ticketData['uid'] != uid) {
        return {'valid': false, 'error': 'Ticket ownership mismatch'};
      }

      if (ticketData['used'] == true) {
        return {
          'valid': false,
          'error': 'Ticket already used',
          'usedAt': ticketData['usedAt'],
        };
      }

      // Mark ticket as used
      await _db.collection('tickets').doc(ticketId).update({
        'used': true,
        'usedAt': FieldValue.serverTimestamp(),
      });

      return {
        'valid': true,
        'ticketId': ticketId,
        'eventName': eventName,
        'userName': ticketData['userName'] ?? 'Unknown',
      };
    } catch (e) {
      return {'valid': false, 'error': e.toString()};
    }
  }

  /// Create a demo ticket (for testing)
  Future<String> createDemoTicket({
    required String eventName,
    required String ticketType,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    final docRef = _db.collection('tickets').doc();
    final ticketId = 'ES26-${docRef.id.substring(0, 8).toUpperCase()}';

    await docRef.set({
      'ticketId': ticketId,
      'uid': user.uid,
      'email': user.email,
      'userName': user.displayName ?? 'User',
      'eventName': eventName,
      'ticketType': ticketType,
      'used': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return ticketId;
  }
}
