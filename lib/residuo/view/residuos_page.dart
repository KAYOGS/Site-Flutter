// ignore: unused_import
import 'package:database_repository/database_repository.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:flutter_firebase_login/residuo/residuo.dart';

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
        listener: (context, state) {},
        child: BlocBuilder<ResiduosBloc, ResiduosState>(
          bloc: BlocProvider.of<ResiduosBloc>(context),
          builder: (context, state) {
            switch (state.status) {
              case ResiduosStatus.loading:
                return LinearProgressIndicator();
              case ResiduosStatus.loaded:
                if (state.residuos!.isEmpty) {
                  return Center(
                    child: Text('A lista de residuos está vazia.'),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: state.residuos!.length,
                  itemBuilder: (context, index) {
                    return ListTile();
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
                        value: ResiduoBloc(user: BlocProvider.of<ResiduosBloc>(context).user, residuo: Residuo.empty),
                        child: ResiduoForm(),
                      )),
            );
          }),
    );
  }
}
