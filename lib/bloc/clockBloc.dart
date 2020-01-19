import 'dart:async';

class ClockBloc {

  //Stream controller
  // final _nightModeStreamController = StreamController<bool>.broadcast();
  final _dateTimeStreamController = StreamController<DateTime>.broadcast();
  final _nightModeStreamController = StreamController<bool>.broadcast();
  final _flareStreamController = StreamController<String>.broadcast();
  final _switchNightModeStreamController = StreamController<String>.broadcast();

  //Stream to get data from pipe
  Stream<DateTime> get dateTimeStream => _dateTimeStreamController.stream;
  //Stream Sink getter (sink to add data in pipe)
  StreamSink<DateTime> get dateTimeSink => _dateTimeStreamController.sink;

  Stream<bool> get nightModeStream => _nightModeStreamController.stream;
  StreamSink<bool> get nightModeSink => _nightModeStreamController.sink;

  Stream<String> get flareStream => _flareStreamController.stream;
  StreamSink<String> get flareSink => _flareStreamController.sink;

  Stream<String> get switchNightModeStream => _switchNightModeStreamController.stream;
  StreamSink<String> get switchNightModeSink => _switchNightModeStreamController.sink;
  

  //singleton
  static final ClockBloc _bloc = ClockBloc.internal();

  factory ClockBloc() {
    return _bloc;
  }

  ClockBloc.internal();


  void initState() {
    DateTime _now = DateTime.now();
    _dateTimeStreamController.add(_now);
    _nightModeStreamController.add(false);
    _flareStreamController.add('switch_to_day');
    _switchNightModeStreamController.add('switch_day');
    _updateTime();
    _backgroundFlare(_now);
  }

  _updateTime() {
    DateTime _now = DateTime.now();
    dateTimeSink.add(_now);
    Timer(
      Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
      _updateTime,
    );
    // _nightMode(_now)
  }

  void activateNightMode() async{
    nightModeSink.add(true);
    flareSink.add('switch_to_night');
  }

  void desactivateNightMode() async{
    nightModeSink.add(false);
    flareSink.add('switch_to_day');
  }

  void switchAnimate(String anim) {
    switch (anim) {
      case 'switch_day':
        switchNightModeSink.add('switch_day');
        break;
      case 'switch_night':
        switchNightModeSink.add('switch_night');
        break;
      case 'night_idle':
        switchNightModeSink.add('night_idle');
        break;
      case 'day_idle':
        switchNightModeSink.add('day_idle');
        break;
      default:
        switchNightModeSink.add('switch_day');
    }
  }

  void backgroundFlareAnimate(String anim) {
    switch (anim) {
      case 'switch_to_day':
        flareSink.add('switch_to_day');
        break;
      case 'switch_to_night':
        flareSink.add('switch_to_night');
        break;
      case 'night_idle':
        flareSink.add('night_idle');
        break;
      case 'day_idle':
        flareSink.add('day_idle');
        break;
      default:
        flareSink.add('switch_to_day');
    }
  }

  void _backgroundFlare(data) {
    if(data.hour >= 17 && data.hour <= 23){
      flareSink.add('switch_to_night');
      switchNightModeSink.add('switch_night');
    }else if(data.hour >= 00 && data.hour <= 05) {
      flareSink.add('switch_to_night');
      switchNightModeSink.add('switch_night');
    }else {
      flareSink.add('switch_to_day');
      switchNightModeSink.add('switch_day');
    }
  }

  void dispose() {
    _dateTimeStreamController.close();
    _nightModeStreamController.close();
    _flareStreamController.close();
    _switchNightModeStreamController.close();
  }

}