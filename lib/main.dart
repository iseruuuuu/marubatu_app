import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marubatu_app/title_page.dart';
import 'model/model.dart';
import 'dart:math';

void main() {
  runApp(TitlePage());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //playerの設定。。。。◯->true   ,✖︎→false
  bool turnOfCircle = true;
  List<PieceStatus> statusList = List.filled(16, PieceStatus.none);
  GameStatus gameStatus = GameStatus.play;
  List<Widget> buildLine = [Container()];
  double lineThickness = 4.0;
  late double lineWidth;
  final List<List<int>> settlementListHorizontal = [
    //横の勝ち方
    [0, 1, 2, 3],
    [4, 5, 6, 7],
    [8, 9, 10, 11],
    [12, 13, 14, 15],
  ];

  //横の勝ち方
  final List<List<int>> settlementListVertical = [
    [0, 4, 8, 12],
    [1, 5, 9, 13],
    [2, 6, 10, 14],
    [3, 7, 11, 15],
  ];
  final List<List<int>> settlementListDiagonal = [
    //斜めの勝ち方
    [0, 5, 10, 15],
    [3, 6, 9, 12],
  ];
  final List<List<int>> settlementListfour = [
    //正方形
    //1列目の
    [0, 1, 4, 5],
    [2, 3, 6, 7],
    [1, 2, 5, 6],
    //２列目
    [4, 5, 8, 9],
    [5, 6, 9, 10],
    [6, 7, 10, 11],
    //3列目
    [8, 9, 12, 13],
    [9, 10, 13, 14],
    [10, 11, 14, 15],
  ];

  @override
  Widget build(BuildContext context) {
    lineWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.blue,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Center(
                        child: Text(
                          '勝ち手一覧',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      content: Image.asset(
                        'assets/images/1.png',
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildRow(),
                SizedBox(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text("クリア"),
                    onPressed: () {
                      setState(() {
                        turnOfCircle = true;
                        statusList = List.filled(16, PieceStatus.none);
                        gameStatus = GameStatus.play;
                        buildLine = [Container()];
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          buildColumn(),
        ],
      ),
    );
  }

  Widget buildRow() {
    switch (gameStatus) {
      case GameStatus.play:
        return Row(
          children: [
            turnOfCircle
                ? const Icon(
              FontAwesomeIcons.circle,
              size: 35,
            )
                : const Icon(
              Icons.clear,
              size: 40,
            ),
            const Text('のターン', style: TextStyle(fontSize: 30)),
          ],
        );
      case GameStatus.draw:
        return const Text("引き分けです。", style: TextStyle(fontSize: 30));
      case GameStatus.settlement:
        return Row(
          children: [
            !turnOfCircle
                ? const Icon(
              FontAwesomeIcons.circle,
              size: 35,
            )
                : const Icon(
              Icons.clear,
              size: 40,
            ),
            const Text("の勝ち!!", style: TextStyle(fontSize: 30)),
          ],
        );
      default:
        return Container();
    }
  }

  Widget buildColumn() {
    List<Widget> _columnChildren = [
      const Divider(
        height: 0.0,
        color: Colors.black,
      ),
    ];
    List<Widget> _rowChildren = [];
    for (int j = 0; j < 4; j++) {
      //横の行を作成するもの
      for (int i = 0; i < 4; i++) {
        int _index = j * 4 + i;
        _rowChildren.add(
          Expanded(
            child: InkWell(
              onTap: gameStatus == GameStatus.play
                  ? () {
                if (statusList[_index] == PieceStatus.none) {
                  statusList[_index] = turnOfCircle
                      ? PieceStatus.circle
                      : PieceStatus.cross;
                  turnOfCircle = !turnOfCircle;
                  confirmResult();
                }
                setState(() {});
              }
                  : null,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Row(
                  children: [
                    Expanded(child: build1(statusList[_index])),
                    (i == 3)
                        ? Container()
                        : const VerticalDivider(
                      width: 0.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      _columnChildren.add(
        Row(
          children: _rowChildren,
        ),
      );
      _columnChildren.add(const Divider(
        height: 0.0,
        color: Colors.black,
      ));
      _rowChildren = [];
    }
    return Stack(
      children: [
        Column(children: _columnChildren),
        Stack(
          children: buildLine,
        ),
      ],
    );
  }

  Container build1(PieceStatus pieceStatus) {
    switch (pieceStatus) {
      case PieceStatus.none:
        return Container();
      case PieceStatus.circle:
        return Container(
          child: const Icon(
            FontAwesomeIcons.circle,
            color: Colors.blue,
            size: 60,
          ),
        );
      case PieceStatus.cross:
        return Container(
          child: const Icon(
            Icons.clear,
            size: 70,
            color: Colors.red,
          ),
        );
      default:
        return Container();
    }
  }

  void confirmResult() {
    if (!statusList.contains(PieceStatus.none)) {
      gameStatus = GameStatus.draw;
    }

    //行における勝敗のパターン
    for (int i = 0; i < settlementListHorizontal.length; i++) {
      if (statusList[settlementListHorizontal[i][0]] ==
          statusList[settlementListHorizontal[i][1]] &&
          statusList[settlementListHorizontal[i][1]] ==
              statusList[settlementListHorizontal[i][2]] &&
          statusList[settlementListHorizontal[i][2]] ==
              statusList[settlementListHorizontal[i][3]] &&
          statusList[settlementListHorizontal[i][0]] != PieceStatus.none) {
        buildLine.add(Container(
          margin: EdgeInsets.only(
              top: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
        ));
        gameStatus = GameStatus.settlement;
      }
    }

    //行における勝敗のパターン
    for (int i = 0; i < settlementListVertical.length; i++) {
      if (statusList[settlementListVertical[i][0]] ==
          statusList[settlementListVertical[i][1]] &&
          statusList[settlementListVertical[i][1]] ==
              statusList[settlementListVertical[i][2]] &&
          statusList[settlementListVertical[i][2]] ==
              statusList[settlementListVertical[i][3]] &&
          statusList[settlementListVertical[i][0]] != PieceStatus.none) {
        buildLine.add(Container(
          margin: EdgeInsets.only(
              left: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
        ));
        gameStatus = GameStatus.settlement;
      }
    }

    //斜めにおける勝敗パターン
    for (int i = 0; i < settlementListDiagonal.length; i++) {
      if (statusList[settlementListDiagonal[i][0]] ==
          statusList[settlementListDiagonal[i][1]] &&
          statusList[settlementListDiagonal[i][1]] ==
              statusList[settlementListDiagonal[i][2]] &&
          statusList[settlementListDiagonal[i][2]] ==
              statusList[settlementListDiagonal[i][3]] &&
          statusList[settlementListDiagonal[i][0]] != PieceStatus.none) {
        buildLine.add(
          Transform.rotate(
            alignment: i == 0 ? Alignment.topLeft : Alignment.topRight,
            angle: i == 0 ? -pi / 4 : pi / 4,
            child: Container(
                width: lineThickness,
                margin: EdgeInsets.only(
                    left: i == 0 ? 0.0 : lineWidth - lineThickness)),
          ),
        );
        gameStatus = GameStatus.settlement;
      }
    }

    //行における勝敗のパターン
    for (int i = 0; i < settlementListfour.length; i++) {
      if (statusList[settlementListfour[i][0]] ==
          statusList[settlementListfour[i][1]] &&
          statusList[settlementListfour[i][1]] ==
              statusList[settlementListfour[i][2]] &&
          statusList[settlementListfour[i][2]] ==
              statusList[settlementListfour[i][3]] &&
          statusList[settlementListfour[i][0]] != PieceStatus.none) {
        buildLine.add(
          Transform.rotate(
            alignment: i == 0 ? Alignment.topLeft : Alignment.topRight,
            angle: i == 0 ? -pi / 4 : pi / 4,
            child: Container(
                width: lineThickness,
                margin: EdgeInsets.only(
                    left: i == 0 ? 0.0 : lineWidth - lineThickness)),
          ),
        );
        gameStatus = GameStatus.settlement;
      }
    }
  }
}
