import 'package:eanalytics/eanalytics.dart' as EAnalytics;
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home('EAnalytics Integration')));
}

class Home extends StatefulWidget {
  Home(this.title) : super();
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    EAnalytics.Eulerian.init('et.eulerian.net',
        requestTrackingAuthorization: true, enableLogger: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eulerian Analytics TRACKERS'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          OutlinedButton(
            onPressed: () {
              EAnalytics.Eulerian.track([
                EAnalytics.EAProperty(path: '/home')
                  ..setEmail('johndoe@eulerian.dev')
                  ..setProperty(EAnalytics.SiteCentric()
                    ..addParam('prop', ['foo', 'baz']))
                  ..setCFlag(
                      EAnalytics.SiteCentric()..addParam('cflag_', ['foo']))
              ]);
            },
            child: Text('EAProperty'),
          ),
          OutlinedButton(
            onPressed: () => EAnalytics.Eulerian.track([
              EAnalytics.EAProducts(path: '/add/product')
                ..addProduct(EAnalytics.Product(
                    ref: 'p1',
                    name: 'Product 1',
                    group: 'group_of_doom',
                    parameters: EAnalytics.Params()
                      ..addParam('foo', 'bar')
                      ..addParam('baz', [1, 2, 3])))
            ]),
            child: Text('Single product'),
          ),
          OutlinedButton(
            onPressed: () => EAnalytics.Eulerian.track([
              EAnalytics.EAProducts(path: '/add/products')
                ..setLocation(latitude: 1.234543, longitude: 54.35322)
                ..setAction(
                    EAnalytics.Action(actionRef: 'test', actionIn: 'test_in'))
                ..addProduct(EAnalytics.Product(
                    ref: 'p1', name: 'Product 1', group: 'group_of_doom'))
                ..addProduct(EAnalytics.Product(
                    ref: 'p2',
                    name: 'Product 2',
                    group: 'group_of_doom',
                    parameters: EAnalytics.Params()
                      ..addParam('foo', {'baz': 'bar'})))
            ]),
            child: Text('Multiple products'),
          )
        ],
      ),
    );
  }
}
