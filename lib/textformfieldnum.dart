import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int getDigits(int n) {
  int dgts = 0;
  while (n != 0) {
    n = (n ~/ 10);
    dgts++;
  }
  return dgts;
}

class TextFormFieldNum extends TextFormField {
  final int min;
  final int max;
  final int initialNum;
  final String labelTextNum;
  final Function onSavedCallback;
  TextFormFieldNum(
      {Key key,
      @required this.initialNum,
      @required this.labelTextNum,
      @required this.min,
      @required this.max,
      @required this.onSavedCallback})
      : super(
            key: key,
            maxLength: getDigits(max),
            initialValue: initialNum.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: InputDecoration(
              labelText: labelTextNum,
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              var n = int.parse(value);
              if (n < min || n > max) {
                return 'range is from $min to $max';
              }
              return null;
            },
            onSaved: (value) => onSavedCallback(int.parse(value)));
}

bool isValidIpv4(String ipv4) {
  final ipRegExp = RegExp(
      r'^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$');
  final match = ipRegExp.firstMatch(ipv4);
  if (match == null) {
    return false;
  } else if (match.groupCount != 4) {
    return false;
  } else {
    var fields = [
      int.tryParse(match[1]),
      int.tryParse(match[2]),
      int.tryParse(match[3]),
      int.tryParse(match[4])
    ];
    for (var field in fields) {
      if ( field == null) {
        return false;
      } else if (field < 0 || field > 255) {
        return false;
      }
    }
    return true;
  }
}

class TextFormFieldIpv4 extends TextFormField {
  final String initialIpv4;
  final String labelTextIpv4;
  final Function onSavedCallback;

  TextFormFieldIpv4(
      {Key key,
      @required this.initialIpv4,
      @required this.labelTextIpv4,
      @required this.onSavedCallback})
      : super(
            key: key,
            maxLength: 15,
            initialValue: initialIpv4,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            decoration: InputDecoration(
              labelText: labelTextIpv4,
              counterText: '',
            ),
            validator: (value) {
              if (isValidIpv4(value)) {
                return null;
              } else {
                return 'Enter a valid IPv4 address (I.E. 127.0.0.1)';
              }
            },
            onSaved: (value) => onSavedCallback(value));
}
