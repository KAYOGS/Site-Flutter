// ignore: unused_import
// ignore_for_file: unused_local_variable

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
    BlocProvider.of<ResiduosBloc>(context).add(ListAllResiduos());
    initializeDateFormatting();
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
          // Obtém o ScaffoldMessenger do contexto atual
          final messenger = ScaffoldMessenger.of(context);

          // Esconde qualquer SnackBar atualmente exibido
          messenger.hideCurrentSnackBar();

          // Verifica o status da operação representada pelo objeto state
          switch (state.status) {
            // Caso o status seja "error"
            case ResiduosStatus.error:
              // Exibe um SnackBar com uma mensagem de erro
              messenger.showSnackBar(
                const SnackBar(
                  // Define a largura do SnackBar como 500 pixels
                  width: 500,
                  // Define o comportamento do SnackBar como flutuante
                  behavior: SnackBarBehavior.floating,
                  // Define o conteúdo do SnackBar como um Texto com a mensagem de erro
                  content: const Text(
                    'Erro inesperado! Tente novamente mais tarde',
                    // Define a cor do texto como vermelho
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
              break;
            // Caso o status não seja "error"
            default:
            // Nenhuma ação é realizada
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
