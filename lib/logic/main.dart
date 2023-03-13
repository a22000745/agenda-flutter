import 'package:flutter/material.dart';
import '../screens/paginaInicio.dart';
import '../screens/paginaLista.dart';
import '../screens/paginaPrincipal.dart';
import '../screens/paginaRegisto.dart';
import 'Agenda.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => Agenda())],
    child: IQueChumbei(),
  ));
}

class IQueChumbei extends StatelessWidget {
  const IQueChumbei({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: IQueChumbeiScreen(),
    );
  }
}

class IQueChumbeiScreen extends StatefulWidget {
  const IQueChumbeiScreen({super.key});

  @override
  _IQueChumbeiScreenState createState() => _IQueChumbeiScreenState();
}

class _IQueChumbeiScreenState extends State<IQueChumbeiScreen> {
  //var agenda = Agenda();
  @override
  void initState() {
    super.initState();
    context.read<Agenda>().criarCincoAvaliacoes();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IQueChumbei',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: PaginaPrincipal(
        screens: [PaginaInicio(), PaginaLista(), PaginaRegisto()],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Inicio",
              backgroundColor: Colors.brown[400]),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Avaliações",
              backgroundColor: Colors.brown[350]),
          BottomNavigationBarItem(
              icon: Icon(Icons.fiber_new),
              label: "Nova Avaliação",
              backgroundColor: Colors.brown[300]),
        ],
      ),
    );
  }
}
