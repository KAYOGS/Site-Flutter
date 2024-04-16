part of 'residuo_bloc.dart';

sealed class ResiduoEvent {
  const ResiduoEvent();
}

final class AddResiduo extends ResiduoEvent {
  const AddResiduo(this.residuo);
  final Residuo residuo;
}

final class UpdateResiduo extends ResiduoEvent {
  const UpdateResiduo(this.residuo);
  final Residuo residuo;
}

final class DeleteResiduo extends ResiduoEvent {
  const DeleteResiduo(this.residuo);
  final Residuo residuo;
}
