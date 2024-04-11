// ignore: unused_import
import 'package:authentication_repository/authentication_repository.dart';
// ignore: unused_import
import 'package:bloc/bloc.dart';
// ignore: unused_import
import 'package:equatable/equatable.dart';
// ignore: unused_import
import 'package:database_repository/database_repository.dart';
part 'residuo_event.dart';
part 'residuo_state.dart';

class ResiduoBloc extends Bloc<ResiduoEvent, ResiduoState> {
  ResiduoBloc(
      {required User user,
      required Residuo residuo,
      ResiduoRepository? residuoRepository})
      : user = user,
        _residuoRepository = residuoRepository ?? ResiduoRepository(),
        super(ResiduoState.initial(residuo: residuo)) {
    on<AddResiduo>((event, emit) async {
      emit(ResiduoState.adding(residuo: event.residuo));
      emit(await _residuoRepository
          .add(userId: user.id, residuo: event.residuo)
          .then(
        (residuo) {
          return ResiduoState.added(residuo: residuo);
        },
        onError: (error, stackTrace) {
          print(error);
          return ResiduoState.error(residuo: event.residuo, error: error);
        },
      ));
    });

    on<UpdateResiduo>((event, emit) async {
      emit(ResiduoState.updating(residuo: event.residuo));
      emit(await _residuoRepository
          .update(userId: user.id, residuo: event.residuo)
          .then(
        (result) {
          return ResiduoState.updated(residuo: event.residuo);
        },
        onError: (error, stackTrace) {
          print(error);
          return ResiduoState.error(residuo: event.residuo, error: error);
        },
      ));
    });

    on<DeleteResiduo>((event, emit) async {
      emit(ResiduoState.deleting(residuo: event.residuo));
      emit(await _residuoRepository
          .delete(userId: user.id, residuo: event.residuo)
          .then(
        (result) {
          return ResiduoState.deleted(residuo: event.residuo);
        },
        onError: (error, stackTrace) {
          print(error);
          return ResiduoState.error(residuo: event.residuo, error: error);
        },
      ));
    });
  }

  final User user;
  // ignore: unused_field
  final ResiduoRepository _residuoRepository;
}
