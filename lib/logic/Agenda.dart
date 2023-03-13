import 'package:flutter/cupertino.dart';

import 'avaliacao.dart';

class Agenda with ChangeNotifier{
  List<Avaliacao> _avaliacoes = [];

  int size(){
    return _avaliacoes.length;
  }
  List<Avaliacao> get avaliacoes => _avaliacoes;
  void guardarLista (Agenda agenda){
    _avaliacoes = agenda.avaliacoes;
    notifyListeners();
  }
  Agenda getThisWeekList() {
    Agenda agendaSemana = Agenda();
    List<Avaliacao> week = <Avaliacao>[];
    for (int a = 0; a < _avaliacoes.length; a++) {
      if (_avaliacoes[a].data.isAfter(DateTime.now()) &&
          _avaliacoes[a]
              .data
              .isBefore(DateTime.now().add(const Duration(days: 7)))) {
        agendaSemana.adicionarAvaliacao(_avaliacoes[a]);
      }
    }
    agendaSemana._avaliacoes.sort((a, b) => a.data.compareTo(b.data));
    return agendaSemana;
  }

  bool apagarAvaliacao(int index) {
    if(index <=_avaliacoes.length){
      _avaliacoes.removeAt(index);
      notifyListeners();
      return true;
    }
      return false;
  }
  bool apagarAvaliacaoOb(Avaliacao avaliacao){
    if(_avaliacoes.contains(avaliacao)){
      _avaliacoes.remove(avaliacao);
      notifyListeners();
      return true;
    }
    return false;
  }

  void criarCincoAvaliacoes() {
    adicionaravaliacao(
        'Linguagens de Programação*Frequencia*2023/03/15*18:00*4*');
    adicionaravaliacao('Sistemas Digitais*Frequencia*2023/03/16*18:00*3*');
    adicionaravaliacao('Sinais e sistemas*Frequencia*2023/06/06*18:00*5*');
    adicionaravaliacao('Computação Movel*Frequencia*2023/06/08*18:00*4*');
    adicionaravaliacao('Bases de Dados*Frequencia*2023/06/10*18:00*4*');
    notifyListeners();
  }

  String nivelMedioPresente() {
    int soma = 0;
    int dias =0;
    final umaSemana = DateTime.now().add(const Duration(days: 7));
    for (int a = 0; a < _avaliacoes.length; a++) {
      if (_avaliacoes[a].data.compareTo(umaSemana)<0) {
        soma += _avaliacoes[a].nivel;
        dias++;
      }
    }
    if (soma == 0) {
      return "Não tem avaliações esta semana!";
    } else {
      return 'A dificuldade esta semana é:\n${soma ~/ dias}';
    }
  }

  String nivelMedioFuturo() {
    int soma = 0;
    int dias = 0;
    final umaSemana = DateTime.now().add(const Duration(days: 7));
    final duasSemana = DateTime.now().add(const Duration(days: 14));
    for (int a = 0; a < avaliacoes.length; a++) {
      if (avaliacoes[a].data.isAfter(umaSemana) &&
          avaliacoes[a].data.isBefore(duasSemana)) {
        soma += avaliacoes[a].nivel;
      }
    }
    if (soma == 0) {
      return "Não tem avaliações para a semana!";
    } else {
      return 'A dificuldade para a semana é:\n${soma ~/ dias}';
    }
  }

  void ordenarListaPorData() {
    avaliacoes.sort((a, b) => a.data.compareTo(b.data));
    notifyListeners();
  }
  void adicionarAvaliacao(Avaliacao avaliacao){
    _avaliacoes.add(avaliacao);
    notifyListeners();
  }
  String adicionaravaliacao(String input) {
    String devolve = "";
    Avaliacao novaAvaliacao;
    if (camposEstaoVazios(input)) {
      return "Os campos têm que estár todos preenchidos!\n(As observações são opcionais)";
    }
    try {
      final _array = input.split('*');
      String _nome = _array[0];
      String _tipo = _array[1];
      if (!tipoCorreto(_tipo)) {
        devolve +=
            "O tipo de avaliação tem ser Frequência, Mini-Teste, Projeto ou Defesa!\n\n";
      }
      DateTime _data = DateTime.now();
      if (dataCorreta(_array[2], _array[3])) {
        _data =
            DateTime.parse("${_array[2].replaceAll('/', '-')}T${_array[3]}");
      } else {
        devolve +=
            "A data tem que ter o formato 'aaaa/mm/dd'!\n(E tem que ser no futuro)\n\n";
      }
      int _nivel = int.parse(_array[4]);
      String _observacoes = _array[5];
      novaAvaliacao = Avaliacao(_nome, _tipo, _data, _nivel, _observacoes);
      if (!novaAvaliacao.dificuldadeCorreta()) {
        devolve += "O nivel de dificuldade tem que ser entre 1 e 5!\n\n";
      }
      if (devolve.isEmpty) {
        _avaliacoes.add(novaAvaliacao);
      }
    } catch (e) {
      devolve += "O nivel de dificuldade tem que ser numerario!";
    }
    notifyListeners();
    return devolve;
  }

  bool camposEstaoVazios(String input) {
    final _array = input.split('*');
    if (_array[0].isEmpty ||
        _array[1].isEmpty ||
        _array[2].isEmpty ||
        _array[3].isEmpty ||
        _array[4].isEmpty) {
      return true;
    } else {
      return false;
    }
  }
  bool dataCorreta(String sData, String sHora) {
    if (sData.contains('/') && sHora.contains(':')) {
      sData = sData.replaceAll('/', '-');
      final dataEscolhida = DateTime.parse("${sData}T$sHora");
      if (dataEscolhida.isAfter(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool tipoCorreto(String input) {
    bool devolve = false;
    switch (input.toLowerCase()) {
      case 'frequencia':
        devolve = true;
        break;
      case 'mini-teste':
        devolve = true;
        break;
      case 'projeto':
        devolve = true;
        break;
      case 'defesa':
        devolve = true;
        break;
      default:
        devolve = false;
    }
    return devolve;
  }
}
