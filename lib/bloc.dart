import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:pagination/model.dart';
import 'package:pagination/network.dart';

import 'package:rxdart/rxdart.dart';

class PhotoBloc {
  final API api = API();
  int pageNumber = 1;
  double pixels = 0.0;

  ReplaySubject<List<Photo>> _subject = ReplaySubject();

  final ReplaySubject<ScrollNotification> _controller = ReplaySubject();

  Observable<List<Photo>> get stream => _subject.stream;
  Sink<ScrollNotification> get sink => _controller.sink;

  PhotoBloc() {
    _subject.addStream(Observable.fromFuture(api.getPhotos(pageNumber)));

    _controller.listen((notification) => loadPhotos(notification));
  }

  Future<void> loadPhotos([
    ScrollNotification notification,
  ]) async {
    if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        pixels != notification.metrics.pixels) {
      pixels = notification.metrics.pixels;

      pageNumber++;
      List<Photo> list = await api.getPhotos(pageNumber);
      _subject.sink.add(list);
    }
  }

  void dispose() {
    _controller.close();
    _subject.close();
  }
}
