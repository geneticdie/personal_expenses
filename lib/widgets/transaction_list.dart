import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transaction added yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.3,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Expanded(
                                child: Text(
                                  transactions[index].title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd()
                                  .format(transactions[index].date),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Expanded(
                                child: Text(
                                  'Rp ${transactions[index].amount}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            RaisedButton(
                              textColor: Theme.of(context).errorColor,
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () => deleteTx(transactions[index].id),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
