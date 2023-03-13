import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/EditarLista.dart';

import '../logic/Agenda.dart';

class Detalhes extends StatelessWidget {
  late Agenda agenda;
  final int index;
  var avancar = false;
  var eliminar = false;
  bool get getVarAvancar => avancar;
  bool get getVarEleminar => getVarEleminar;
  Detalhes({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    agenda = context.read<Agenda>();
    return Scaffold(
        appBar: AppBar(title: Text('IQueChumbei')),
        body: ListView(
          children: [
            showtitle('Detalhes'),
            showInformation(agenda.avaliacoes[index].nomeDisciplina),
            showInformation(agenda.avaliacoes[index].tipoAvaliacao),
            showInformation(
                "${agenda.avaliacoes[index].getStrData()} ás ${agenda
                    .avaliacoes[index].getStrHour()}h"),
            showInformation("Dificuldade: ${agenda.avaliacoes[index].nivel}"),
            showInformation(agenda.avaliacoes[index].observacoes),
            editButton(context)
          ],
        ));
  }

  Widget showtitle(String title) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ));
  }

  Widget showInformation(String info) {
    return Container(
        height: 50,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.brown[300],
          border: Border.all(color: Colors.black, width: 4),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          info,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ));
  }

  Widget editButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: (MediaQuery.of(context).size.width /2),
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
              agenda.avaliacoes[index].data.isBefore(DateTime.now())
                  ? showAlertDialog(context)
                  : {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarLista(
                              listIndex: index,
                            ),
                          ))
                    };
            },
            child: Text('Editar',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
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
        Navigator.of(context).pop();
      },
      child: Text('Ok'),
    );
    AlertDialog alert = avancar
        ? eliminar
            ? AlertDialog(
                title: Text('Sucesso!!'),
                content: Text(
                    'O registo de avaliação selecionado foi eleminado com sucesso'),
                actions: [okButton],
              )
            : AlertDialog(
                title: Text('Sucesso!!'),
                content: Text('Não deve chrgar aqui'),
                actions: [okButton],
              )
        : AlertDialog(
            title: Text('Erro!'),
            content:
                Text('Só podem ser editados registos de avaliações futuras.'),
            actions: [okButton],
          );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
