import 'package:flutter/material.dart';



class DialogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text('削除確認', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),),
          content: Text('計算や履歴が削除されます\n'
              'よろしいでしょうか？', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),),
          actions: [
            Divider(color: Colors.black,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('いいえ',
                      style: TextStyle(color: Colors.blue, fontSize: 20,),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return DialogScreen();
  }
}