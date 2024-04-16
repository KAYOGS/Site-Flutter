part of 'residuo_bloc.dart';

enum ResiduoStatus {
  initial,
  adding,
  added,
  updating,
  updated,
  deleting,
  deleted,
  error
}

final class ResiduoState extends Equatable {
  const ResiduoState._(
      {required this.status, required this.residuo, this.error});

  const ResiduoState.initial({required Residuo residuo})
      : this._(status: ResiduoStatus.initial, residuo: residuo);
  const ResiduoState.adding({required Residuo residuo})
      : this._(status: ResiduoStatus.adding, residuo: residuo);
  const ResiduoState.added({required Residuo residuo})
      : this._(status: ResiduoStatus.added, residuo: residuo);
  const ResiduoState.updating({required Residuo residuo})
      : this._(status: ResiduoStatus.updating, residuo: residuo);
  const ResiduoState.updated({required Residuo residuo})
      : this._(status: ResiduoStatus.updated, residuo: residuo);
  const ResiduoState.deleting({required Residuo residuo})
      : this._(status: ResiduoStatus.deleting, residuo: residuo);
  const ResiduoState.deleted({required Residuo residuo})
      : this._(status: ResiduoStatus.deleted, residuo: residuo);
  const ResiduoState.error({required Residuo residuo, required Object? error})
      : this._(status: ResiduoStatus.error, residuo: residuo, error: error);

  final ResiduoStatus status;
  final Residuo residuo;
  final Object? error;

  bool get isBusy {
    if (this.status
        case ResiduoState.adding ||
            ResiduoState.updating ||
            ResiduoState.deleting) return true;
    return false;
  }

  bool get isValid => this.status != ResiduoStatus.deleted;

  @override
  List<Object> get props => [status, residuo];
}
