class MailContent  {
  int id;
  String titulo;
  String data;
  String autor;
  String mensagem;
  bool resposta;
  bool visualizada;

  MailContent({this.titulo, this.autor, this.data, this.mensagem, this.resposta, this.visualizada});
  
  String getTitulo() => this.titulo;
  String getAutor() => this.autor;
  String getData() => this.data;
  String getMensagem() => this.mensagem;
  bool getResposta() => this.resposta;
  bool getVisualizada() => this.visualizada;
}