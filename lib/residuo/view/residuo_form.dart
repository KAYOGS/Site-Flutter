// ignore: unused_import
import 'package:database_repository/database_repository.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/residuo/bloc/residuo_bloc.dart';
// ignore: unused_import
import 'package:flutter_firebase_login/residuo/residuo.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:intl/date_symbol_data_local.dart';

class ResiduoForm extends StatefulWidget {
  const ResiduoForm({super.key});

  @override
  State<StatefulWidget> createState() => _ResiduoFormState();
}

class _ResiduoFormState extends State<ResiduoForm> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _validator = GlobalKey<FormState>();

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

            case ResiduoStatus.added || ResiduoState.updated:
              menssager.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Residuo salvar com sucesso.',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            // ignore: unreachable_switch_case
            case ResiduoStatus.deleted:
              menssager
                  .showSnackBar(
                    const SnackBar(
                      width: 500,
                      behavior: SnackBarBehavior.floating,
                      content: const Text(
                        'Residuo excluido com sucesso.',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  )
                  .closed
                  .then((reason) => Navigator.pop(context));
            // ignore: unreachable_switch_case
            case ResiduoStatus.error:
              menssager.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Erro inesperado!',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            default:
          }
        },
        child: SingleChildScrollView(
          child: BlocBuilder<ResiduoBloc, ResiduoState>(
            bloc: BlocProvider.of<ResiduoBloc>(context),
            builder: (context, state) {
              return Column(
                children: [
                  (state.isBusy)
                      ? LinearProgressIndicator()
                      : SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Form(
                          key: _validator,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Gerenciamento adequado de '
                                  ' residuos sólidos, incluindo'
                                  ' coleta, reciclagem, tratamento'
                                  ' e disposição final de maneira'
                                  ' ambientalmente segura.'),
                              _NameInput(_validator),
                              _SizeInput(),
                              _SolutionInput(),
                              _DateInput(),
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
      ),
      floatingActionButton: BlocBuilder<ResiduoBloc, ResiduoState>(
        bloc: BlocProvider.of<ResiduoBloc>(context),
        builder: (context, state) {
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: (state.isBusy || !state.isValid)
                ? null
                : () {
                    if (_validator.currentState!.validate()) {
                      if (state.residuo.isEmpty) {
                        BlocProvider.of<ResiduoBloc>(context)
                            .add(AddResiduo(state.residuo));
                      } else {
                        BlocProvider.of<ResiduoBloc>(context)
                            .add(UpdateResiduo(state.residuo));
                      }
                    }
                  },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BlocBuilder<ResiduoBloc, ResiduoState>(
        bloc: BlocProvider.of<ResiduoBloc>(context),
        builder: (context, state) {
          // ignore: unused_local_variable
          final _dipacthDelete = () => BlocProvider.of<ResiduoBloc>(context)
              .add(DeleteResiduo(state.residuo));
          return BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      (state.isBusy || !state.isValid || state.residuo.isEmpty)
                          ? null
                          : () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: const Text(
                                      'Tem certeza de que quer excluir este residuo?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancelar'),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'Excluir');
                                        _dipacthDelete();
                                      },
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Excluir'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput(GlobalKey<FormState> validator)
      : this._validator = validator;

  // ignore: unused_field
  final GlobalKey<FormState> _validator;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, ResiduoState>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state) {
        return TextFormField(
          autofocus: true,
          enabled: !state.isBusy && state.isValid,
          initialValue: state.residuo.name,
          onChanged: (name) {
            state.residuo.name = name;
            _validator.currentState!.validate();
          },
          validator: (name) => name!.isEmpty ? 'Nome obrigatório' : null,
          keyboardType: TextInputType.text,
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

// ignore: unused_element
class _SizeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, ResiduoState>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state) {
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          initialValue: (state.residuo.size ?? '').toString(),
          onChanged: (size) => state.residuo.size = int.parse(size),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: 'Quantidade',
              hintText: 'Quantidade de residuo',
              helperText: 'Quantidade de residuo gerado e tratado'),
        );
      },
    );
  }
}

// ignore: unused_element
class _SolutionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResiduoBloc, ResiduoState>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state) {
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          initialValue: state.residuo.solution ?? '',
          onChanged: (solution) => state.residuo.solution = solution,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Tratamento',
            hintText: 'Tratamento para o residuo',
            helperText: 'Metodos de tratamento utilizados como reciclagem'
                ' compostagem, incineração, aterro sanitario',
          ),
        );
      },
    );
  }
}

// ignore: unused_element
class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    return BlocBuilder<ResiduoBloc, ResiduoState>(
      bloc: BlocProvider.of<ResiduoBloc>(context),
      builder: (context, state) {
        try {
          _controller.text =
              DateFormat.yMMMMd('pt-BR').format(state.residuo.date!);
        } catch (exception) {}

        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          readOnly: true,
          controller: _controller,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.date_range),
              labelText: 'Calendario',
              hintText: 'Selecionar data',
              helperText: 'Data do cadastro do residuo'),
          onTap: () async {
            // ignore: unused_local_variable
            final now = state.residuo.date ?? DateTime.now();
            // ignore: unused_local_variable
            state.residuo.date = await showDatePicker(
                context: context,
                locale: Locale('pt', 'BR'),
                initialDate: now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5));

            try {
              _controller.text =
                  DateFormat.yMMMMd('pt-BR').format(state.residuo.date!);
            } catch (exception) {}
          },
        );
      },
    );
  }
}
