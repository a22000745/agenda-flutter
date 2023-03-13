import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/logic/Agenda.dart';

void main() {
  test("Form - Registo vazio", () {
    final Agenda agenda = Agenda();
    final real = agenda.adicionaravaliacao("*Frequencia*2023/03/11*18:00*4*");
    expect(real,
        "Os campos têm que estár todos preenchidos!\n(As observações são opcionais)");
  });
  test("Form - Data errada", () {
    final Agenda agenda = Agenda();
    final real = agenda.adicionaravaliacao(
        "Matematica*Frequencia*1/2/3*18:00*4*");
    expect(real,
        "A data tem que ter o formato 'aaaa/mm/dd'!\n(E tem que ser no futuro)\n\n");
  });
  test("Form - Dificuldade errada", () {
    final Agenda agenda = Agenda();
    final real = agenda.adicionaravaliacao(
        "Portugues*Frequencia*2023/03/11*18:00*pouca*");
    expect(real, "O nivel de dificuldade tem que ser numerario!");
  });
  test("Form - Tipo errado", () {
    final Agenda agenda = Agenda();
    final real = agenda.adicionaravaliacao("ingles*teste*2023/03/11*18:00*4*");
    expect(real,
        "O tipo de avaliação tem ser Frequência, Mini-Teste, Projeto ou Defesa!\n\n");
  });
  test("inicio - media de esta semana", () {
    final Agenda agenda = Agenda();
    agenda.criarCincoAvaliacoes();
    final real = agenda.nivelMedioPresente();
    expect(real, "A dificuldade esta semana é:\n3");
  });
  test("inicio - media sem avaliações", () {
    final Agenda agenda = Agenda();
    agenda.criarCincoAvaliacoes();
    final real = agenda.nivelMedioFuturo();
    expect(real, "Não tem avaliações para a semana!");
  });
  test("inicio - apagar item da lista", () {
    final Agenda agenda = Agenda();
    agenda.criarCincoAvaliacoes();
    agenda.apagarAvaliacao(1);
    final real = agenda.avaliacoes.length;
    expect(real, 4);
  });
  test("lista - tentar editar item antigo", () {
    final Agenda agenda = Agenda();
    agenda.criarCincoAvaliacoes();
    final devolveu = agenda.adicionaravaliacao(
        "ingles*frequencia*2023/03/11*18:00*4*");
    final real = devolveu.contains(
        "A data tem que ter o formato 'aaaa/mm/dd'!\n(E tem que ser no futuro)\n\n");
    expect(real, true);
  });
}