import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/logic/Agenda.dart';

import 'detalhesLista.dart';

class PaginaInicio extends StatefulWidget {
  bool avancar = false;
  bool eliminar = false;
  late Agenda agenda;
  late Agenda agendaSemana;

  PaginaInicio({super.key});

  @override
  State<StatefulWidget> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  @override
  Widget build(BuildContext context) {
    widget.agenda = context.watch<Agenda>();
    widget.agendaSemana = widget.agenda.getThisWeekList();
    return ListView(
      children: [
        showTitle('Inicio'),
        showInformation(widget.agenda.nivelMedioPresente()),
        showInformation(widget.agenda.nivelMedioFuturo()),
        /*Consumer<Agenda>(
          builder: (context, lista, child){
            return lista.avaliacoes.isEmpty
                ?escreve('Não há avaliações!')
                : listTitle();
        },
        ),*/
        SizedBox(
          height: 10,
        ),
        listTitle(),
        Center(
          child: Container(
            height: 220,
            width: (MediaQuery.of(context).size.width - 20),
            decoration: BoxDecoration(
              color: Colors.brown[200],
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: listBox(),
          ),
        ),
      ],
    );
  }

  Widget listBox() {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 220,
          width: (MediaQuery.of(context).size.width - 20),
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: widget.agendaSemana.size(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 110,
                  width: (MediaQuery.of(context).size.width - 20),
                  child: Row(
                    children: [
                      dateBox(index),
                      SizedBox(width: 5),
                      infoBox(index),
                      SizedBox(width: 5),
                      iconBox(index),
                    ],
                  ));
            },
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    ));
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
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
      child: Text('Ok'),
    );
    AlertDialog alert = widget.avancar
        ? widget.eliminar
            ? AlertDialog(
                title: Text('Sucesso!!'),
                content: Text(
                    'O registo de avaliação selecionado foi eleminado com sucesso'),
                actions: [okButton],
              )
            : AlertDialog(
                title: Text('Erro!!'),
                content: Text('Não deve chegar aqui'),
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

  Widget deleteButton(int index) {
    return SizedBox(
      width: 90,
      height: 20,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(CupertinoColors.black),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          onPressed: () {
            widget.agendaSemana.avaliacoes[index].data.isBefore(DateTime.now())
                ? showAlertDialog(context)
                : {
                    widget.avancar = true,
                    widget.eliminar = true,
                    showAlertDialog(context),
                    widget.avancar = false,
                    widget.eliminar = false,
                    widget.agenda.apagarAvaliacaoOb(
                        widget.agendaSemana.avaliacoes[index]),
                  };
            setState(() {});
          },
          child: Text('Eliminar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
    );
  }

  Widget iconBox(int index) {
    return Container(
        height: 100,
        width: (MediaQuery.of(context).size.width / 7),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            shareButton(index),
            editButton(index),
          ],
        ));
  }

  Widget shareButton(int index) {
    return IconButton(
      icon: Icon(Icons.share,color: Colors.black,),
      color: Colors.white,
      onPressed: () {
        _onShareWithResult(context, index);
      },
    );
  }

  void _onShareWithResult(BuildContext context, int index) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult = await Share.shareWithResult(
        'Mensagem do Dealer!!',
        subject:
            "Vamos ter avaliação de ${Provider.of<Agenda>(context).avaliacoes[index].nomeDisciplina}, em ${Provider.of<Agenda>(context).avaliacoes[index].getStrData()}  ${Provider.of<Agenda>(context).avaliacoes[index].getStrHour()}, com a dificuldade de ${Provider.of<Agenda>(context).avaliacoes[index].nivel}} numa escala de 1 a5.\n\nObservações para esta avaliação:  ${Provider.of<Agenda>(context).avaliacoes[index].observacoes}",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  Widget editButton(int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      color: Colors.black,
      onPressed: () {
        widget.agendaSemana.avaliacoes[index]
                .data
                .isBefore(DateTime.now())
            ? showAlertDialog(context)
            : {
                widget.avancar = true,
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detalhes(
                        index: index,
                      ),
                    ))
              };
      },
    );
  }

  Widget dateBox(int index) {
    return Container(
      height: 100,
      width: (MediaQuery.of(context).size.width / 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              widget.agendaSemana.avaliacoes[index]
                  .getStrData(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 5),
          escreve(
              "${widget.agendaSemana.avaliacoes[index].getStrHour()} h"),
          SizedBox(height: 5),
          deleteButton(index)
        ],
      ),
    );
  }

  Widget infoBox(int index) {
    return Container(
        height: 100,
        width: (MediaQuery.of(context).size.width / 4) * 1.8,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              widget.agendaSemana.avaliacoes[index]
                  .nomeDisciplina,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Row(children: [
              escreve(' Dificuldade: '),
              Text(
                ' ${widget.agendaSemana.avaliacoes[index].nivel}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            Row(
              children: [
                escreve(' Tipo: '),
                Text(
                  ' ${widget.agendaSemana.avaliacoes[index].tipoAvaliacao}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget escreve(String texto) {
    return Text(texto,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold));
  }

  Widget showInformation(String info) {
    return Container(
        height: 90,
        margin: EdgeInsets.all(10),
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

  Widget showTitle(String title) {
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

  Widget listTitle() {
    return Center(
      child: Container(
          height: 40,
          width: (MediaQuery.of(context).size.width - 40),
          decoration: BoxDecoration(
              color: Colors.grey[400],
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          alignment: Alignment.center,
          child: Text(
            "Avaliações de esta semana",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )),
    );
  }
}
