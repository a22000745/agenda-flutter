import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/Agenda.dart';

class EditarLista extends StatefulWidget {
  final int listIndex;

  const EditarLista({super.key, required this.listIndex});

  @override
  State<StatefulWidget> createState() => _EditarListaState();
}

class _EditarListaState extends State<EditarLista> {
  String _avisos = "";
  var _controllerName = TextEditingController();
  var _controllerTipe = TextEditingController();
  var _controllerDate = TextEditingController();
  var _controllerHour = TextEditingController();
  var _controllerDifficulty = TextEditingController();
  var _controllerObsevations = TextEditingController();
  bool voltar = false;

  @override
  void initState() {
    _controllerName.text =
        context.read<Agenda>().avaliacoes[widget.listIndex].nomeDisciplina;
    _controllerTipe.text =
        context.read<Agenda>().avaliacoes[widget.listIndex].tipoAvaliacao;
    _controllerDate.text =
        context.read<Agenda>().avaliacoes[widget.listIndex].getStrData();
    _controllerHour.text =
        context.read<Agenda>().avaliacoes[widget.listIndex].getStrHour();
    _controllerDifficulty.text =
        context.read<Agenda>().avaliacoes[widget.listIndex].nivel.toString();
    _controllerObsevations.text =
        context.read<Agenda>().avaliacoes[widget.listIndex].observacoes;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('IQueChumbei')),
        body: ListView(
          padding: EdgeInsets.all(30),
          children: [
            showTitle("Editar Avaliação"),
            const SizedBox(height: 20),
            buildNameInput(),
            const SizedBox(height: 10),
            buildTipeInput(),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                buildDateInput(context),
                const SizedBox(width: 20),
                buildHourInput(context)
              ],
            ),
            const SizedBox(height: 10),
            buildDifficultyInput(),
            const SizedBox(height: 10),
            buildObsevationsInput(),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              saveButton(context),
              const SizedBox(width: 10),
              deleteButton(context)
            ]),
          ],
        ),
      );

  Future openWarning() {
    Widget okButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(CupertinoColors.systemYellow),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      onPressed: () {
        Navigator.of(context).pop('dialog');
        voltar = true;
      },
      child: Text('Ok'),
    );
    return showDialog(
        context: context,
        builder: (context) => _avisos.contains(
                "O registo de avaliação selecionado foi editado com sucesso.")
            ? AlertDialog(
                title: Text('Sucesso!!'),
                content: Text(_avisos),
                actions: [okButton],
              )
            : _avisos.contains(
                    "O registo de avaliação selecionado foi editado com sucesso.")
                ? AlertDialog(
                    title: Text('Sucesso!'),
                    content: Text(_avisos),
                    actions: [okButton],
                  )
                : AlertDialog(
                    title: Text('Erro!'),
                    content: Text(_avisos),
                    actions: [okButton],
                  ));
  }

  Widget showTitle(String title) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ));
  }

  Widget saveButton(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 3) * 1.1,
      height: 80,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  CupertinoColors.systemYellow),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          onPressed: () async {
            _avisos = "";
            _avisos = context.read<Agenda>().adicionaravaliacao(
                "${_controllerName.text}*${_controllerTipe.text}*${_controllerDate.text}*${_controllerHour.text}*${_controllerDifficulty.text}*${_controllerObsevations.text}");
            _avisos.isNotEmpty
                ? openWarning()
                : {
                    _avisos =
                        "O registo de avaliação selecionado foi editado com sucesso.",
                    context.read<Agenda>().apagarAvaliacao(widget.listIndex),
                    await openWarning(),
                    setState(() {
                      Navigator.pop(context);
                    }),
                  };
          },
          child: Text('Guardar',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    );
  }

  Widget deleteButton(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 3) * 1.1,
      height: 80,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(CupertinoColors.black),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          onPressed: () {
            _avisos =
                "O registo de avaliação selecionado foi eliminado com sucesso.";
            context.read<Agenda>().apagarAvaliacao(widget.listIndex);
            openWarning();
            _controllerObsevations.clear();
            _controllerDifficulty.clear();
            _controllerHour.clear();
            _controllerDate.clear();
            _controllerTipe.clear();
            _controllerName.clear();
          },
          child: Text('Apagar',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    );
  }

  Widget buildNameInput() => TextField(
        controller: _controllerName,
        decoration: InputDecoration(
          hintText: _controllerName.text,
          labelText: 'Nome da disciplina',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _controllerName.clear(),
          ),
          border: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        maxLines: 1,
      );

  Widget buildTipeInput() => TextField(
        controller: _controllerTipe,
        decoration: InputDecoration(
          hintText: _controllerTipe.text,
          labelText: 'Tipo de avaliação',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _controllerTipe.clear(),
          ),
          border: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        maxLines: 1,
      );

  Widget buildDateInput(BuildContext context) => SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 40,
        child: TextField(
          controller: _controllerDate,
          decoration: InputDecoration(
            hintText: _controllerDate.text,
            labelText: 'Data da avaliação',
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _controllerDate.clear(),
            ),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.done,
          maxLines: 1,
        ),
      );

  Widget buildHourInput(BuildContext context) => SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 40,
        child: TextField(
          controller: _controllerHour,
          decoration: InputDecoration(
            hintText: _controllerHour.text,
            labelText: 'Hora da avaliação',
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _controllerHour.clear(),
            ),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.done,
          maxLines: 1,
        ),
      );

  Widget buildDifficultyInput() => TextField(
        controller: _controllerDifficulty,
        decoration: InputDecoration(
          hintText: _controllerDifficulty.text,
          labelText: 'Nivel de dificuldade 1-5',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _controllerDifficulty.clear(),
          ),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        maxLines: 1,
      );

  Widget buildObsevationsInput() => TextField(
        controller: _controllerObsevations,
        decoration: InputDecoration(
          hintText: _controllerObsevations.text,
          labelText: 'Observações',
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _controllerObsevations.clear(),
          ),
          border: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        maxLength: 200,
      );
}
