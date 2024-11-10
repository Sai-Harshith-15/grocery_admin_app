import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Globals {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final userId = auth.currentUser?.uid;
  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert to DateTime
    return DateFormat('dd MMM yyyy, hh:mm a')
        .format(dateTime); // Format to "day month year, time"
  }
}
