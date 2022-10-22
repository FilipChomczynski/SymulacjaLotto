import 'package:flutter/material.dart';
import 'Results.dart';

class ChooseNumberPage extends StatefulWidget {
  const ChooseNumberPage({Key? key}) : super(key: key);

  @override
  State<ChooseNumberPage> createState() => _ChooseNumberPageState();
}

class _ChooseNumberPageState extends State<ChooseNumberPage> {
  late int clickedButton;
  int amountOfClickedButtons = 0;
  List<bool> isButtonClicked = [];
  List<int> selectedNumbers = [];

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    amountOfClickedButtons = 0;
    isButtonClicked = [];
    selectedNumbers = [];
    for (var i = 1; i<=49; i++) {
      isButtonClicked.add(false);
    }
  }

  void addNumber(int i) {
    setState(() {
      clickedButton = i - 1;
      isButtonClicked[clickedButton] = !isButtonClicked[clickedButton];
      amountOfClickedButtons = isButtonClicked.where((item) => item == true).length;
    });

    if (amountOfClickedButtons >= 6) {
      for (var i = 0; i<49; i++) {
        if (isButtonClicked[i] == true) {
          selectedNumbers.add(i + 1);
        }
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Results(numbers: selectedNumbers,);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        ListView(
          children: [
            const Center(child:
            Text(
              "Symulator Lotto",
              style: TextStyle(height: 5, fontSize: 30),
            ),
            ),
            const Center(child: Text("Zaznacz 6 numerów aby przejść do losowania.", style: TextStyle(height: 6, fontSize: 15),),),
            GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisCount: 7,
              shrinkWrap: true,
              children: <Widget>[
                for (var i = 1; i<=49; i++) Center(child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: isButtonClicked[i - 1]? MaterialStateProperty.all<Color>(Colors.white): MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: isButtonClicked[i - 1]? MaterialStateProperty.all<Color>(Colors.deepPurple): null,
                  ),
                  onPressed: () {
                    addNumber(i);
                  },
                  child: Text('$i'),
                )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}