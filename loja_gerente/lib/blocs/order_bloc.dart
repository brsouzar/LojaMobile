import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria {READ_FIRST, READ_LAST}

class OrderBloc extends BlocBase {

  OrderBloc() : super(0) {
    _addOrdersListener();
  }

  final _ordersController = BehaviorSubject<List>();

  SortCriteria? _criteria;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> orderslist = [];

  Stream<List> get outOders => _ordersController.stream;

  void _addOrdersListener() {
     _firestore.collection('orders').snapshots().listen((snapshot) {
         for (var change in snapshot.docChanges) {
           String oid = change.doc.id;
           switch (change.type) {
             case DocumentChangeType.added:
               orderslist.add(change.doc);
               break;
             case DocumentChangeType.modified:
               orderslist.removeWhere((order) => order.id == oid);
               orderslist.add(change.doc);
               break;
             case DocumentChangeType.removed:
               orderslist.removeWhere((order) => order.id == oid);
               break;
           }
         }
         _sort();
     });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria!) {
      case SortCriteria.READ_FIRST:
        orderslist.sort((a,b) {
          Map<String, dynamic> ordera = a.data() as Map<String, dynamic>;
          int sa = ordera['status'];
          Map<String, dynamic> orderb = b.data() as Map<String, dynamic>;
          int sb = orderb['status'];

          if (sa < sb) return 1;
          else if (sa > sb)  return - 1;
          else return 0;

        });
        break;
      case SortCriteria.READ_LAST:
        orderslist.sort((a,b) {
          Map<String, dynamic> ordera = a.data() as Map<String, dynamic>;
          int sa = ordera['status'];
          Map<String, dynamic> orderb = b.data() as Map<String, dynamic>;
          int sb = orderb['status'];

          if (sa > sb) return 1;
          else if (sa < sb)  return - 1;
          else return 0;

        });
        break;
    }
    _ordersController.add(orderslist);
  }
  @override
  void dispose() {
    _ordersController.close();
  }

}