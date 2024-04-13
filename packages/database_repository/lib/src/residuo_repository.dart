import '../database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template repository}
/// Repository whitch managers residuos.
/// {@endtemplate}

class ResiduoRepository {
  /// {@macro residuo_repository}

  ResiduoRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<List<Residuo>> listAll({required String userId}) {
    try {
      return _firebaseFirestore
          .collection('residuos')
          .doc(userId)
          .collection('residuo')
          .orderBy('name')
          .snapshots()
          .map((result) {
        final List<Residuo> residuos = <Residuo>[];
        result.docs.forEach((doc) {
          // ignore: unused_local_variable
          final data = doc.data();
          // ignore: unused_local_variable
          var date;

          try {
            date = (data['date'] as Timestamp).toDate();
          } catch (exception) {}
          residuos.add(Residuo(
              id: doc.id,
              name: data['name'],
              size: data['size'],
              solution: data['solution'],
              date: data['date']));
        });

        return residuos;
      });
    } catch (exception) {
      rethrow;
    }
  }

  Future<Residuo> add({required String userId, required Residuo residuo}) {
    try {
      // ignore: unused_local_variable
      var date;

      try {
        date = Timestamp.fromDate(residuo.date!);
      } catch (exception) {}

      return _firebaseFirestore
          .collection('residuos')
          .doc(userId)
          .collection('residuo')
          .add({
        'name': residuo.name,
        'size': residuo.size,
        'solution': residuo.solution,
      }).then((result) {
        return Residuo(
            id: result.id,
            name: residuo.name,
            size: residuo.size,
            solution: residuo.solution,
            date: residuo.date);
      });
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> update({required String userId, required Residuo residuo}) {
    try {
      try {
        // ignore: unused_local_variable
        var date;

        try {
          date = Timestamp.fromDate(residuo.date!);
        } catch (exception) {}

        return _firebaseFirestore
            .collection('residuos')
            .doc(userId)
            .collection('residuo')
            .doc(residuo.id)
            .update({
          'name': residuo.name,
          'size': residuo.size,
          'solution': residuo.solution,
          'date': residuo.date,
        });
      } catch (exception) {
        rethrow;
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> delete({required String userId, required Residuo residuo}) {
    try {
      return _firebaseFirestore
          .collection('residuos')
          .doc(userId)
          .collection('residuo')
          .doc(residuo.id)
          .delete();
    } catch (exception) {
      rethrow;
    }
  }
}
