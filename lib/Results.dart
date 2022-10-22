import 'dart:isolate';

import 'package:flutter/material.dart';
import 'dart:math';

class Results extends StatefulWidget {
  const Results({Key? key, required this.numbers}) : super(key: key);
  final List<int> numbers;
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  bool isDrawingLots = false;
  List<int> generatedNumbers = [];

  int tries = 0;

  int zeroHits = 0;
  int oneHits = 0;
  int twoHits = 0;
  int threeHits = 0;
  int fourHits = 0;
  int fiveHits = 0;
  int sixHits = 0;

  // args
  // 0 - isDrawingLots
  // 1 - generatedNumbers
  // 2 - widget
  // 3 - zeroHits
  // 4 - oneHits
  // 5 - twoHits
  // 6 - threeHits
  // 7 - fourHits
  // 8 - fiveHits
  // 9 - sixHits
  static void drawLots(List<dynamic> args) {
    final random = Random();
    int next(int min, int max) => min + random.nextInt(max - min);
    args[0] = true;

    while (args[0]) {
      args[1] = [];
      for (var i = 0; i < 6; i++) {
        args[1].add(next(1, 49));
      }

      Set<int> commonItems =
          args[2].numbers.toSet().intersection(args[1].toSet());
      switch (commonItems.length) {
        case 0:
          {
            args[3]++;
          }
          break;
        case 1:
          {
            args[4]++;
          }
          break;
        case 2:
          {
            args[5]++;
          }
          break;
        case 3:
          {
            args[6]++;
          }
          break;
        case 4:
          {
            args[7]++;
          }
          break;
        case 5:
          {
            args[8]++;
          }
          break;
        case 6:
          {
            args[9]++;
          }
          break;
      }

      int tries =
          args[3] + args[4] + args[5] + args[6] + args[7] + args[8] + args[9];

      if (tries >= 400000 || commonItems.length == 6) {
        args[0] = false;
        args[10].send([
          args[3],
          args[4],
          args[5],
          args[6],
          args[7],
          args[8],
          args[9],
          tries
        ]);
      }
    }
  }

  void startMachine() async {
    setState(() {
      isDrawingLots = true;
    });
    isDrawingLots = true;
    List<ReceivePort> receiver = [];
    for (var i = 0; i < 8; i++) {
      receiver.add(ReceivePort());
      await Isolate.spawn(drawLots, [
        isDrawingLots,
        generatedNumbers,
        widget,
        zeroHits,
        oneHits,
        twoHits,
        threeHits,
        fourHits,
        fiveHits,
        sixHits,
        receiver[i].sendPort
      ]);

      final data = await receiver[i].first;
      setState(() {
        zeroHits = data[0];
        oneHits = data[1];
        twoHits = data[2];
        threeHits = data[3];
        fourHits = data[4];
        fiveHits = data[5];
        sixHits = data[6];
      });
    }

    setState(() {
      isDrawingLots = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const Center(
                child: Text(
              "Wyniki",
              style: TextStyle(height: 2, fontSize: 35),
            )),
            Center(
              child: !isDrawingLots
                  ? SizedBox(
                      height: 60,
                      width: 130,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: startMachine,
                        child: const Text("Losuj"),
                      ))
                  : const Text("Losowanie...", style: TextStyle(height: 3, fontSize: 15)),
            ),
            Center(
                child: ListView(
              shrinkWrap: true,
              children: [
                const Center(
                    child: Text(
                  "Trafione: ",
                  style: TextStyle(fontSize: 25),
                )),
                GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(26),
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Center(
                          child: Text("1: $oneHits",
                              style: const TextStyle(height: 1, fontSize: 20))),
                      Center(
                          child: Text("2: $twoHits",
                              style: const TextStyle(height: 1, fontSize: 20))),
                      Center(
                          child: Text("3: $threeHits",
                              style: const TextStyle(height: 1, fontSize: 20))),
                      Center(
                          child: Text("4: $fourHits",
                              style: const TextStyle(height: 1, fontSize: 20))),
                      Center(
                          child: Text("5: $fiveHits",
                              style: const TextStyle(height: 1, fontSize: 20))),
                      Center(
                          child: Text("6: $sixHits",
                              style: const TextStyle(height: 1, fontSize: 20)))
                    ]),
              ],
            )),
            Center(child:  SizedBox(
                height: 50,
                width: 200,
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      isDrawingLots = false;
                      Navigator.pop(context);
                    },
                    child: const Text("Wróć do wyboru numerów."))))

          ],
        ),
      ),
    );
  }
}
