import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rpgmaster/models/character_model.dart';

final charactersForCampaignProvider =
StreamProvider.family<List<CharacterModel>, String>((ref, campaignId) {
  final query = FirebaseFirestore.instance
      .collection('characters')
      .where('campaignId', isEqualTo: campaignId)
      .orderBy('createdAt', descending: true);

  return query.snapshots().map(
        (snap) => snap.docs
        .map((doc) => CharacterModel.fromDoc(doc))
        .toList(),
  );
});
