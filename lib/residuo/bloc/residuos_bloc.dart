// ignore: unused_import
import 'package:authentication_repository/authentication_repository.dart';
// ignore: unused_import
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';
part 'residuos_event.dart';
part 'residuos_state.dart';

class ResiduosBloc extends Bloc<ResiduosEvent, ResiduosState> {
  ResiduosBloc({required User user, ResiduoRepository? residuoRepository})
      : user = user,
        _residuoRepository = residuoRepository ?? ResiduoRepository(),
        super(ResiduosState.initial()) {
    on<ListAllResiduos>((event, emit) async {
      emit(ResiduosState.loading());
      final listAll = _residuoRepository.listAll(userId: user.id);
      listAll.listen((residuos) {
        emit(ResiduosState.changed(residuos: residuos));
      });
      await emit.forEach(
        listAll,
        onData: (List<Residuo> residuos) {
          return ResiduosState.loaded(residuos: residuos);
        },
        onError: (error, stackTrace) {
          print(error);
          return ResiduosState.error(error: error);
        },
      );
    });
  }

  final User user;
  final ResiduoRepository _residuoRepository;
}
