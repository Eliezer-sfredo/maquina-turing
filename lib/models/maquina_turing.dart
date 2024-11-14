class MaquinaTuring {
  Map<String, Map<String, List<String>>> transicoes;
  String estadoAtual;
  List<String> fita = []; // Inicialização da fita vazia
  int posicaoCabeca = 0;
  int iteracoes = 0;
  Set<String> estadosAceitacao;

  MaquinaTuring({
    required this.transicoes,
    required this.estadoAtual,
    required this.estadosAceitacao,
  });

  void inicializarFita(String entrada) {
    fita = ['.'] + entrada.split('') + ['β']; // Redefinir fita ao iniciar
    posicaoCabeca = 0; // Redefinir posição da cabeça
    estadoAtual = "q0";
    iteracoes = 0;
  }

  String executarPasso() {
    iteracoes++;
    String simboloAtual = fita[posicaoCabeca];

    if (!transicoes.containsKey(estadoAtual) ||
        !transicoes[estadoAtual]!.containsKey(simboloAtual)) {
      return "rejected";
    }

    var transicao = transicoes[estadoAtual]![simboloAtual]!;
    estadoAtual = transicao[0];
    fita[posicaoCabeca] = transicao[1];
    posicaoCabeca += transicao[2] == "D" ? 1 : -1;

    if (estadosAceitacao.contains(estadoAtual)) {
      return "accepted";
    }
    return "running";
  }
}
