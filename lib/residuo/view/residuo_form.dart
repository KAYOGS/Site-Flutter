// ignore: unused_import
import 'package:database_repository/database_repository.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:flutter_firebase_login/residuo/residuo.dart';

class ResiduoForm extends StatefulWidget {
  const ResiduoForm({super.key});

  @override
  State<StatefulWidget> createState() => _ResiduoFormState();
}

class _ResiduoFormState extends State<ResiduoForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Residuo'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: BlocListener<ResiduoBloc, ResiduoState>(
        bloc: BlocProvider.of<ResiduoBloc>(context),
        listener: (context, state) {
          // ignore: unused_local_variable
          final menssager = ScaffoldMessenger.of(context);
          menssager.hideCurrentSnackBar();
          switch (state.status) {
            // ignore: constant_pattern_never_matches_value_type
            case ResiduosStatus.error:
              menssager.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Erro inesperado! tente novamente mais tarde.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            default:
          }
        },
        child: BlocBuilder<ResiduoBloc, ResiduoState>(
          bloc: BlocProvider.of<ResiduoBloc>(context),
          builder: (context, state) {
            return Column(
              children: [
                (state.isBusy) ? LinearProgressIndicator() : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Gerenciamento adequado de '
                                ' residuos sólidos, incluindo'
                                ' coleta, reciclagem, tratamento'
                                ' e disposição final de maneira'
                                ' ambientalmente segura.'),
                            _NameInput(),
                          ]
                              .map(
                                (widget) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: widget,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      //floatingActionButton: ,
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, ResiduoState>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Nome',
            hintText: 'Nome do residuo',
            helperText: 'Residuos orgânicos, plásticos, metais,'
                ' vidro, papel, entre outros',
          ),
        );
      },
    );
  }
}
