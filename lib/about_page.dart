import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  static const double profileMargin = 10.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "このアプリについて",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("このアプリはモールス信号を光を使って送受信するアプリです"),
                  const Text("現在は英数字と一部の記号しか送受信できません。"),
                  const Text(
                      "入力欄に送信したい文字を入力して、入力欄の下の送信ボタンを押すと端末のライトが明滅してモールス信号を送信します。"),
                  const Text("受信する場合は、右下のカメラボタンを押してカメラを起動します。"),
                  const Text("カメラプレビュー中央の枠にモールス信号で明滅する光をとらえてください。"),
                  const Text(
                      "光源が暗いタイミングで右下のボタンを押すと、受信を始めます（現状それほど精度は高くありません）。"),
                  const Text("コピーアイコンを押せば、受信した文字列をコピーできます。"),
                  const Text("間違った文字列を受信した場合は、クリアアイコンで消去できます。"),
                  const Text(""),
                  Container(
                      margin: const EdgeInsets.all(profileMargin),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text('制作者：'),
                            InkWell(
                              child: const Text('淡中 圏',
                                  style: TextStyle(color: Colors.blue)),
                              onTap: () =>
                                  launchUrlString("https://tannakaken.xyz"),
                            )
                          ]),
                          TableRow(children: [
                            const Text('メールアドレス：'),
                            InkWell(
                              child: const Text('tannakaken@gmail.com',
                                  style: TextStyle(color: Colors.blue)),
                              onTap: () => launchUrlString(
                                  "mailto:tannakaken@gmail.com"),
                            )
                          ]),
                          TableRow(children: [
                            const Text('bluesky：'),
                            InkWell(
                              child: const Text('tannakaken',
                                  style: TextStyle(color: Colors.blue)),
                              onTap: () => launchUrlString(
                                  "https://bsky.app/profile/tannakaken.xyz"),
                            )
                          ])
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.all(profileMargin),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text("戻る"),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      )),
                ])));
  }
}
