import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:dio/dio.dart';

String formatAmt(double a) {
  FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
    amount: a,
    settings: MoneyFormatterSettings(symbol: 'RM')
  );
  return fmf.output.symbolOnLeft;
}

void handleError(BuildContext context, DioError error, void Function() onYes) {
  String msg = error.message;
  if (error.type == DioErrorType.CONNECT_TIMEOUT) {
    msg = 'Connection Timeout';
  }

  else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
    msg = 'Receive Timeout';
  }

  else if (error.type == DioErrorType.RESPONSE) {
    msg = 'Error occurred - ${error.response.statusCode}';
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(''),
        content: Text('$msg. Do you want to retry ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('YES'),
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
          ),
        ],
      );
    }
  );
}