import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginaPrincipal extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> items;

  const PaginaPrincipal({super.key, required this.screens, required this.items});
  @override
  State<StatefulWidget> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('IQueChumbei')),
      body: widget.screens[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _onTapped,
        items: widget.items,
        iconSize: 35,
        type:  BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          elevation: 5
      ),
    );
  }
  void _onTapped(int newPageIndex) {
    setState(() {
      _pageIndex = newPageIndex;
    });
  }
}
