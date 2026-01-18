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

  /// Get a specific ticket by ticket ID
  Future<DocumentSnapshot<Map<String, dynamic>>?> getTicketByTicketId(
      String ticketId) async {
    final query = await _db
        .collection('tickets')
        .where('ticketId', isEqualTo: ticketId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first;
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

      // Find ticket by ticketId field (not document ID)
      final querySnapshot = await _db
          .collection('tickets')
          .where('ticketId', isEqualTo: ticketId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'valid': false, 'error': 'Ticket not found in database'};
      }

      final ticketDoc = querySnapshot.docs.first;
      final ticketData = ticketDoc.data();

      // Verify ownership
      if (ticketData['uid'] != uid) {
        return {'valid': false, 'error': 'Ticket ownership mismatch'};
      }

      // Check if already used
      if (ticketData['used'] == true) {
        final usedAt = ticketData['usedAt'];
        String usedAtStr = 'Unknown time';
        if (usedAt is Timestamp) {
          final date = usedAt.toDate();
          usedAtStr = '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
        }
        return {
          'valid': false,
          'error': 'Ticket already used',
          'usedAt': usedAtStr,
        };
      }

      // Mark ticket as used
      await ticketDoc.reference.update({
        'used': true,
        'usedAt': FieldValue.serverTimestamp(),
      });

      return {
        'valid': true,
        'ticketId': ticketId,
        'eventName': ticketData['eventName'] ?? eventName,
        'userName': ticketData['userName'] ?? 'Unknown',
        'ticketType': ticketData['ticketType'] ?? 'General',
        'email': ticketData['email'] ?? '',
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

    // Get user data from Firestore for name
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};
    final userName = userData['name'] ?? user.displayName ?? 'User';

    final docRef = _db.collection('tickets').doc();
    final ticketId = 'ES26-${docRef.id.substring(0, 8).toUpperCase()}';

    await docRef.set({
      'ticketId': ticketId,
      'uid': user.uid,
      'email': user.email,
      'userName': userName,
      'eventName': eventName,
      'ticketType': ticketType,
      'used': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return ticketId;
  }

  /// Buy a ticket (actual purchase flow)
  Future<String> purchaseTicket({
    required String eventName,
    required String ticketType,
    required double price,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    // Get user data
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};
    final userName = userData['name'] ?? user.displayName ?? 'User';

    final docRef = _db.collection('tickets').doc();
    final ticketId = 'ES26-${docRef.id.substring(0, 8).toUpperCase()}';

    await docRef.set({
      'ticketId': ticketId,
      'uid': user.uid,
      'email': user.email,
      'userName': userName,
      'eventName': eventName,
      'ticketType': ticketType,
      'price': price,
      'used': false,
      'purchasedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return ticketId;
  }
}
