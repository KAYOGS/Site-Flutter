// ignore: unused_import
import 'package:database_repository/database_repository.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:flutter_firebase_login/residuo/residuo.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:intl/date_symbol_data_local.dart';

class ResiduosPage extends StatefulWidget {
  const ResiduosPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResiduosPageState();
}

class _ResiduosPageState extends State<ResiduosPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    BlocProvider.of<ResiduosBloc>(context).add(ListAllResiduos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de residuos'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: BlocListener<ResiduosBloc, ResiduosState>(
        bloc: BlocProvider.of<ResiduosBloc>(context),
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          switch (state.status) {
            case ResiduosStatus.error:
              messenger.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Erro inesperado! Tente novamente mais tarde',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            default:
          }
        },
        child: BlocBuilder<ResiduosBloc, ResiduosState>(
          bloc: BlocProvider.of<ResiduosBloc>(context),
          builder: (constext, state) {
            switch (state.status) {
              case ResiduosStatus.loading:
                return const LinearProgressIndicator();
              case ResiduosStatus.loaded:
                if (state.residuos!.isEmpty) {
                  return const Center(
                    child: const Text('A lista de residuos está vazia.'),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (constext, index) => const Divider(),
                  itemCount: state.residuos!.length,
                  itemBuilder: (constext, index) {
                    String date = '';
                    try {
                      date = DateFormat.yMMMMd('pt-BR')
                          .format(state.residuos![index].date!);
                    } catch (exception) {}
                    return ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text(state.residuos![index].name[0]),
                        ),
                      ),
                      title: Text(state.residuos![index].name),
                      subtitle: Text(date),
                      trailing:
                          Text((state.residuos![index].size ?? '').toString()),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<ResiduosPage>(
                            builder: (_) => BlocProvider.value(
                                  value: ResiduoBloc(
                                      user:
                                          BlocProvider.of<ResiduosBloc>(context)
                                              .user,
                                      residuo: state.residuos![index]),
                                  child: ResiduoForm(),
                                )),
                      ),
                    );
                  },
                );
              default:
                return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<ResiduosPage>(
                  builder: (_) => BlocProvider.value(
                        value: ResiduoBloc(
                            user: BlocProvider.of<ResiduosBloc>(context).user,
                            residuo: Residuo.empty),
                        child: ResiduoForm(),
                      )),
            );
          }),
    );
  }
}
