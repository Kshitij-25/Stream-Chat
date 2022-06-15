import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DisplayErrorMessage extends StatelessWidget {
  const DisplayErrorMessage({Key? key, this.error}) : super(key: key);

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Oh no, Something went wrong.' 'Please check your config. $error',
      ),
    );
  }
}
