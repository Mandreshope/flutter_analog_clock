import 'package:analog_clock/bloc/clockBloc.dart';
import 'package:analog_clock/page/analogClock.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ClockBloc _clockBloc = ClockBloc();

  @override
  void initState() {
    _clockBloc.initState();
    print('instance clockBloc in main : ${_clockBloc.hashCode}');
    super.initState();
  }

  @override
  void dispose() {
    _clockBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _clockBloc.nightModeStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return MaterialApp(
          title: 'Analog clock',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            brightness: snapshot.data == true ? Brightness.dark : Brightness.light
          ),
          home: AnalogClock()
        );
      },
    );
  }
}
