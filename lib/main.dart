import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Montserrat',
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                button: TextStyle(color: Colors.white)),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
//    Transaction(
//      id: 't1',
//      title: 'New Shoes',
//      amount: 300000,
//      date: DateTime.now(),
//    ),
//    Transaction(
//      id: 't2',
//      title: 'Weekly Groceries',
//      amount: 450000,
//      date: DateTime.now(),
//    )
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _addNewTransaction(String txTitle, int txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildiOSContent() {
    return CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        children: <Widget>[
          GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context)),
        ],
      ),
    );
  }

  Widget _buildAndroidContent() {
    return AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildiOSContent()
        : _buildAndroidContent();

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));

    final pageBody = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._buildLandscapeContent(
              mediaQuery,
              appBar,
              txListWidget,
            ),
          if (!isLandscape)
            ..._buildPortraitContent(
              mediaQuery,
              appBar,
              txListWidget,
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
