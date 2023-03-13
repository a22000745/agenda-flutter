class Avaliacao{
  String _nomeDisciplina;
  String _tipoAvaliacao;
  DateTime _data;
  int _nivel;
  String _observacoes;
  Avaliacao(this._nomeDisciplina, this._tipoAvaliacao, this._data, this._nivel, this._observacoes);
  String get nomeDisciplina => _nomeDisciplina;
  String get tipoAvaliacao => _tipoAvaliacao;
  DateTime get data =>_data;
  String getStrData() => "${_data.year}/${_data.month.toString().padLeft(2,'0')}/${_data.day.toString().padLeft(2,'0')}";
  String getStrHour() => "${_data.hour.toString()}:${_data.minute.toString().padLeft(2,'0')}";
  int get nivel => _nivel;
  String get observacoes => _observacoes.isEmpty? "Observações": _observacoes;

  bool dificuldadeCorreta(){
    if(_nivel < 1 || _nivel > 5){
      return false;
    }else{
      return true;
    }
  }
}
