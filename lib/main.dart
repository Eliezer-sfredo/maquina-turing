import 'package:flutter/material.dart';
import 'models/maquina_turing.dart';

void main() {
  runApp(TuringApp());
}

class TuringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TuringHome(),
    );
  }
}

class TuringHome extends StatefulWidget {
  @override
  _TuringHomeState createState() => _TuringHomeState();
}

class _TuringHomeState extends State<TuringHome> {
  final TextEditingController _controller = TextEditingController();
  late MaquinaTuring maquinaTuring;
  String resultado = "";
  int iteracoes = 0;

  @override
  void initState() {
    super.initState();
    inicializarMaquina();
  }

  void inicializarMaquina() {
    maquinaTuring = MaquinaTuring(
      transicoes: {
        "q0": {
          ".": ["q0", ".", "D"],
          "0": ["q0", "0", "D"],
          "1": ["q0", "1", "D"],
          "β": ["q1", "β", "E"]
        },
        "q1": {
          "0": ["q2", "0", "D"]
        },
      },
      estadoAtual: "q0",
      estadosAceitacao: {"q2"},
    );
  }

  void iniciarMaquina() {
    String entrada = _controller.text;
    if (entrada.contains(RegExp(r'[^01]'))) {
      setState(() {
        resultado = "Erro: Insira apenas caracteres binários.";
      });
      return;
    }
    maquinaTuring.inicializarFita(entrada);
    atualizarInterface();
  }

  void proximoPasso() {
    String status = maquinaTuring.executarPasso();
    atualizarInterface();
    if (status == "accepted" || status == "rejected") {
      setState(() {
        resultado =
            "Sentença ${status == "accepted" ? "aceita" : "rejeitada"} em ${maquinaTuring.iteracoes} iterações.";
      });
    }
  }

  void atualizarInterface() {
    setState(() {
      iteracoes = maquinaTuring.iteracoes;
    });
  }

  void reiniciarMaquina() {
    _controller.clear();
    inicializarMaquina();
    setState(() {
      resultado = "";
      iteracoes = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TDE Compiladores - Eliézer Sfredo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Máquina de Turing",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Digite um número binário",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: iniciarMaquina,
              child: Text("Iniciar"),
            ),
            SizedBox(height: 20),
            // Fita com rolagem horizontal
            Container(
              height: 100, // Altura fixa para a área da fita
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: maquinaTuring.fita.asMap().entries.map((entry) {
                    int index = entry.key;
                    String simbolo = entry.value;
                    bool isHeadPosition = index == maquinaTuring.posicaoCabeca;
                    return Container(
                      width: 50, // Largura fixa para as células da fita
                      height: 70, // Altura fixa para as células da fita
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isHeadPosition
                            ? const Color.fromARGB(255, 124, 68, 255)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color.fromARGB(255, 124, 33, 243),
                            width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isHeadPosition)
                            Icon(
                              Icons.arrow_drop_down,
                              color: const Color.fromARGB(255, 124, 33, 243),
                              size: 20, // Reduzindo o tamanho da seta
                            ),
                          Text(
                            simbolo,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isHeadPosition ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Estado Atual: ${maquinaTuring.estadoAtual}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Iterações: $iteracoes", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: proximoPasso,
                  child: Text("Próximo Passo"),
                ),
                ElevatedButton(
                  onPressed: reiniciarMaquina,
                  child: Text("Reiniciar"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              resultado,
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
