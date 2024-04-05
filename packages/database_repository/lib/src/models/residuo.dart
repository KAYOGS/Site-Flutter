/// {@template residuo}
/// User model
///
/// [Residuo.empty] represents a new residuo.
/// {@endtemplate}
class Residuo {
  /// {@macro residuo}
  Residuo(
      {required this.id,
      required this.name,
      this.size,
      this.solution,
      this.date});

  /// The current residuo's id.
  late final String id;

  /// The current residuo's name (display name).
  String name;

  /// The current residuo's size.
  int? size;

  /// The current residuo's solution.
  String? solution;

  /// The current residuo's solution date.
  DateTime? date;

  /// Empty residuo which represents a new residuo.
  static Residuo get empty => Residuo(id: '', name: '');

  /// Empty residuo which represents a new residuo.
  Residuo get clone => Residuo(
        id: this.id,
        name: this.name,
        size: this.size,
        solution: this.solution,
        date: this.date,
      );

  /// Convenience getter to determine whether the current residuo is empty.
  bool get isEmpty => this.id.isEmpty;

  /// Convenience getter to determine whether the current residuo is valid.
  bool get isValid => !this.name.isEmpty;
}
