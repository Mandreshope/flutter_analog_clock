import 'package:analog_clock/bloc/clockBloc.dart';
import 'package:analog_clock/widget/containerHand.dart';
import 'package:analog_clock/widget/drawnHand.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

  /// Total distance traveled by a second or a minute hand, each second or minute,
  /// respectively.
  final radiansPerTick = radians(360 / 60);

  /// Total distance traveled by an hour hand, each hour, in radians.
  final radiansPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {

  AnalogClock({Key key}) : super(key:key);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {

  final ClockBloc _clockBloc = ClockBloc();

  @override
  void initState() {
    _clockBloc.initState();
    print('instance clockBloc in analog_clolck : ${_clockBloc.hashCode}');
    super.initState();
  }

  @override
  void dispose() {
    _clockBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final customTheme = Theme.of(context).brightness == Brightness.light
    ? Theme.of(context).copyWith(
        // Hour hand.
        primaryColor: Colors.blueGrey[900],
        // Minute hand.
        highlightColor: Colors.blueGrey[700],
        // Second hand.
        accentColor: Colors.black,
        backgroundColor: Color(0xFFD2E3FC),
      )
    : Theme.of(context).copyWith(
        primaryColor: Colors.grey[200],
        highlightColor: Colors.grey[300],
        accentColor: Colors.white,
        backgroundColor: Color(0xFF3C4043),
      );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            StreamBuilder(
              initialData: 'switch_to_day',
              stream: _clockBloc.flareStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                // print(snapshot.data);
                return FlareActor('assets/daynight.flr', 
                callback: (v) {
                  if(v == 'switch_to_day'){
                    _clockBloc.backgroundFlareAnimate('day_idle');
                  }else {
                    _clockBloc.backgroundFlareAnimate('night_idle');
                  }
                  
                },
                fit: BoxFit.cover,
                animation: snapshot.data,
              );}
            ),
            Center(
              child: AspectRatio(
                aspectRatio: 5/3,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder(
                    stream: _clockBloc.dateTimeStream,
                    initialData: DateTime.now(),
                    builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) => Container(
                      child: Stack(
                        children: [
                          MediaQuery.of(context).orientation == Orientation.portrait
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.5),
                                  color: customTheme.backgroundColor.withOpacity(0),
                                  border: Border.all(color: customTheme.primaryColor)
                                ),
                                width: width*0.57,
                              ),
                            )
                          :
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.5),
                                  color: customTheme.backgroundColor.withOpacity(0),
                                  border: Border.all(color: customTheme.primaryColor)
                                ),
                                width: width*0.53,
                              ),
                            ),

                          StreamBuilder(
                            stream: _clockBloc.nightModeStream,
                            initialData: false,
                            builder: (BuildContext context, AsyncSnapshot<bool> nightSnap) {
                              return Center(
                                child: Container(
                                  width: width,
                                  child: nightSnap.data == true 
                                  ?
                                    Image.asset('assets/images/background2.png')
                                  :
                                    Image.asset('assets/images/background.png'),
                                ),
                              );
                            },
                          ),

                          // Example of a hand drawn with [CustomPainter].
                          DrawnHand(
                            color: customTheme.highlightColor,
                            thickness: 10,
                            size: 0.5,
                            angleRadians: snapshot.data.minute * radiansPerTick,
                          ),
                          // Example of a hand drawn with [Container].
                          ContainerHand(
                            color: Colors.transparent,
                            size: 0.3,
                            angleRadians: snapshot.data.hour * radiansPerHour + (snapshot.data.minute / 60) * radiansPerHour,
                            child: Transform.translate(
                              offset: Offset(0.0, -60.0),
                              child: Container(
                                width: 32,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: customTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),

                          DrawnHand(
                            color: customTheme.accentColor,
                            thickness: 4,
                            size: 0.7,
                            angleRadians: snapshot.data.second * radiansPerTick,
                          ),

                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: customTheme.accentColor,
                              ),
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ],
                      )
                    )
                  )
                )
              ),
            ),
          ],
        ) 
      ),
    );
  }
}
