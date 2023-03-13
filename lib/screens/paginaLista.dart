import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/EditarLista.dart';
import 'package:untitled/screens/detalhesLista.dart';
import '../logic/Agenda.dart';
import 'package:share_plus/share_plus.dart';

class PaginaLista extends StatefulWidget {
  bool avancar = false;
  bool eliminar = false;

  PaginaLista({super.key});

  @override
  State<StatefulWidget> createState() => _PaginaListaState();
}

class _PaginaListaState extends State<PaginaLista> {
  @override
  void initState() {
    super.initState();
    context.read<Agenda>().ordenarListaPorData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showTitle('Lista de Avaliações'),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(12),
                itemCount: context.read<Agenda>().avaliacoes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) => _doAction(context, index),
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Eliminar',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    child: Container(
                        height: 120,
                        width: (MediaQuery.of(context).size.width - 20),
                        child: Row(
                          children: [
                            dateBox(index),
                            SizedBox(width: 2),
                            infoBox(index),
                            SizedBox(
                              width: 2,
                            ),
                            iconBox(index),
                          ],
                        )),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  _doAction(BuildContext context, int index) {
    context.read<Agenda>().avaliacoes[index].data.isAfter(DateTime.now())
        ? {
            widget.avancar = true,
            widget.eliminar = true,
            showAlertDialog(context),
            setState(() {
              widget.avancar = false;
              widget.eliminar = false;
              context.read<Agenda>().apagarAvaliacao(index);
            }),
          }
        : {
            widget.avancar = false,
            showAlertDialog(context),
            setState(() {}),
          };
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

  Widget escreve(String texto) {
    return Text(texto,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget infoBox(int index) {
    return Container(
        height: 110,
        width: (MediaQuery.of(context).size.width / 4) * 1.8,
        decoration: BoxDecoration(
          color: Colors.brown[200],
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              context.read<Agenda>().avaliacoes[index].nomeDisciplina,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: [
              escreve(' Dificuldade: '),
              Text(
                ' ${context.read<Agenda>().avaliacoes[index].nivel}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            Row(
              children: [
                escreve(' Tipo: '),
                Text(
                  ' ${context.read<Agenda>().avaliacoes[index].tipoAvaliacao}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget iconBox(int index) {
    return Container(
        height: 110,
        width: (MediaQuery.of(context).size.width / 7),
        decoration: BoxDecoration(
          color: Colors.brown[200],
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            shareButton(index),
            editButton(index),
          ],
        ));
  }

  Widget dateBox(int index) {
    return Container(
      height: 110,
      width: (MediaQuery.of(context).size.width / 4) * 1.2,
      decoration: BoxDecoration(
        color: Colors.brown[200],
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.read<Agenda>().avaliacoes[index].getStrData(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 10),
          escreve("${context.read<Agenda>().avaliacoes[index].getStrHour()} h"),
          SizedBox(height: 10),
          deleteButton(index)
        ],
      ),
    );
  }

  void _onShareWithResult(BuildContext context, int index) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult = await Share.shareWithResult(
        'Mensagem do Dealer!!',
        subject:
            "Vamos ter avaliação de ${context.read<Agenda>().avaliacoes[index].nomeDisciplina}, em ${context.read<Agenda>().avaliacoes[index].getStrData()}  ${context.read<Agenda>().avaliacoes[index].getStrHour()}, com a dificuldade de ${context.read<Agenda>().avaliacoes[index].nivel}} numa escala de 1 a5.\n\nObservações para esta avaliação:  ${context.read<Agenda>().avaliacoes[index].observacoes}",
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

  Widget deleteButton(int index) {
    return SizedBox(
      width: 100,
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
            context
                    .read<Agenda>()
                    .avaliacoes[index]
                    .data
                    .isBefore(DateTime.now())
                ? showAlertDialog(context)
                : {
                    widget.avancar = true,
                    widget.eliminar = true,
                    showAlertDialog(context),
                    context.read<Agenda>().apagarAvaliacao(index),
                    widget.avancar = false,
                    widget.eliminar = false,
                    setState(() {}), //falta fazer o swipe
                  };
          },
          child: Text('Eliminar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
    );
  }

  Widget shareButton(int index) {
    return IconButton(
      icon: Icon(Icons.share),
      color: Colors.white,
      onPressed: () {
        _onShareWithResult(context, index);
      },
    );
  }

  Widget editButton(int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      color: Colors.white,
      onPressed: () {
        context.read<Agenda>().avaliacoes[index].data.isBefore(DateTime.now())
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

  Widget goToEdit(int index) {
    return EditarLista(
      listIndex: index,
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
