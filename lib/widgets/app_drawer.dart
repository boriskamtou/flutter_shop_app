import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:flutter_shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Manage Products'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
