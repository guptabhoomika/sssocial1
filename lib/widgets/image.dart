import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 1),
  const StaggeredTile.count(1, 2),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(1, 2),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(3, 1),
  const StaggeredTile.count(1, 1),
  const StaggeredTile.count(4, 1),
  const StaggeredTile.count(1, 2),
  const StaggeredTile.count(3, 2)
];
List<Widget> _tiles = const <Widget>[
  const Tile(Colors.green, Icons.widgets),
  const Tile(Colors.lightBlue, Icons.wifi),
  const Tile(Colors.amber, Icons.panorama_wide_angle),
  const Tile(Colors.brown, Icons.map),
  const Tile(Colors.deepOrange, Icons.send),
  const Tile(Colors.indigo, Icons.airline_seat_flat),
  const Tile(Colors.red, Icons.bluetooth),
  const Tile(Colors.pink, Icons.battery_alert),
  const Tile(Colors.purple, Icons.desktop_windows),
  const Tile(Colors.blue, Icons.radio),
  const Tile(Colors.lightGreen,Icons.ac_unit),
  const Tile(Colors.lightBlueAccent,Icons.account_balance)
];
class Images extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
         child :Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: new StaggeredGridView.count(
              crossAxisCount: 4,
              staggeredTiles: _staggeredTiles,
              children: _tiles,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4.0),
            )));
      
    
  }
}
class Tile extends StatelessWidget {
  const Tile(this.backgroundColor, this.iconData);
  final Color backgroundColor;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {},
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            
                         
                                                      child: new Icon(
                iconData,
                color: Colors.white,
              ),
                          ),
            ),
          ),
        
      
    );
  }
}
