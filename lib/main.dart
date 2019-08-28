import 'package:pagination/model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:pagination/bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PhotoBloc>(
      builder: (context) => PhotoBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Photo> photos;
  List<int> maxPhotos = [];

  @override
  void initState() {
    super.initState();

    maxPhotos.addAll(List.generate(5000, (x) => x));
    photos = [];
  }

  bool onNotification(ScrollNotification scrollInfo, PhotoBloc bloc) {
    // print(scrollInfo);
    if (scrollInfo is OverscrollNotification) {
      bloc.sink.add(scrollInfo);
    }
    return false;
  }

  Widget buildListView(
    BuildContext context,
    AsyncSnapshot<List<Photo>> snapshot,
  ) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }

    photos.addAll(snapshot.data);

    return ListView.builder(
      itemCount: (maxPhotos.length > photos.length)
          ? photos.length + 1
          : photos.length,
      itemBuilder: (context, index) => (index == photos.length)
          ? Container(
              margin: EdgeInsets.all(8),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListTile(
              leading: CircleAvatar(
                child: Image.network(photos[index].thumbnailUrl),
              ),
              title: Text(photos[index].id.toString()),
              subtitle: Text(photos[index].title),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PhotoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagination App"),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) => onNotification(notification, bloc),
        child: StreamBuilder<List<Photo>>(
          stream: bloc.stream,
          builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
            return buildListView(context, snapshot);
          },
        ),
      ),
    );
  }
}
