import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/Agenda.dart';

class PaginaRegisto extends StatelessWidget {
  final _controllerName = TextEditingController();
  final _controllerTipe = TextEditingController();
  final _controllerDate = TextEditingController();
  final _controllerHour = TextEditingController();
  final _controllerDifficulty = TextEditingController();
  final _controllerObsevations = TextEditingController();
  late Agenda agenda;
  String _avisos = "";

  PaginaRegisto({super.key,});
  static const snackBar = SnackBar(
    content: Text('Yay! A SnackBar!'),
  );
  @override
  Widget build(BuildContext context) {
    agenda =  Provider.of<Agenda>(context, listen: false);
    return Center(
      child: ListView(
        padding: EdgeInsets.all(30),
        children: [
          showTitle("Nova Avaliação"),
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
          const SizedBox(height: 20),
          submitButton(context)
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(CupertinoColors.systemYellow),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
      child: Text('Ok'),
    );
    AlertDialog alert =
        _avisos.contains("A avaliação foi registada com sucesso.")
            ? AlertDialog(
                title: Text('Sucesso!!'),
                content: Text(_avisos),
                actions: [okButton],
              )
            : AlertDialog(
                title: Text('Erro!'),
                content: Text(_avisos),
                actions: [okButton],
              );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Widget showTitle(String title){
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
          textAlign: TextAlign.center,)
    );
  }
  Widget submitButton(BuildContext context){
    return SizedBox(
      width: 80,
      height: 70,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  CupertinoColors.systemYellow),
              foregroundColor:
              MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          onPressed: () {
            _avisos = "";
            _avisos = agenda.adicionaravaliacao(
                "${_controllerName.text}*${_controllerTipe.text}*${_controllerDate.text}*${_controllerHour.text}*${_controllerDifficulty.text}*${_controllerObsevations.text}");
            _avisos.isNotEmpty
                ? showAlertDialog(context)
                : {
              _avisos = "A avaliação foi registada com sucesso.",
              showAlertDialog(context),
              _controllerObsevations.clear(),
              _controllerDifficulty.clear(),
              _controllerHour.clear(),
              _controllerDate.clear(),
              _controllerTipe.clear(),
              _controllerName.clear()
            };
          },
          child: Text('Agendar',
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold))),
    );
  }
  Widget buildNameInput() => TextField(
        controller: _controllerName,
        decoration: InputDecoration(
          hintText: 'Computação Movel',
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
          hintText: 'Frequencia',
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
            hintText: '2023/12/01',
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
            hintText: '10:00',
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
          hintText: '5',
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
