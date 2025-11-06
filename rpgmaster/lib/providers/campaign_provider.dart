import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rpgmaster/models/campaign_model.dart';

final userCampaignsProvider =
StreamProvider.autoDispose<List<Campaign>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const Stream.empty();
  }

  final query = FirebaseFirestore.instance
      .collection('campaigns')
      .where('userId', isEqualTo: user.uid)
      .orderBy('CreatedAt', descending: true);

  return query.snapshots().map(
        (snap) => snap.docs
        .map((doc) => Campaign.fromDoc(doc))
        .toList(),
  );
});
