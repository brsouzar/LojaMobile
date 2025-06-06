import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  UserBloc() : super(0) {
    _addUsersListener();
  }


  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;
  final Map<String, Map<String, dynamic>> _users = {};
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
 void dispose() {
    _usersController.close();
  }

  void onChangedSearch(String search) {
     if (search.trim().isEmpty) {
       _usersController.add(_users.values.toList());
     }
     else {
       _usersController.add(_filter(search.trim()));
     }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList());
    filteredUsers.retainWhere((user) {
      return user['name'].toString().toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
  }

  Map<String, dynamic> getUser(String uid) {
   return _users[uid]!;
  }

  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      for (DocumentChange<Map<String, dynamic>> changes in snapshot.docChanges) {
        String uid = changes.doc.id;
        DocumentSnapshot<Map<String, dynamic>> dataDocs = changes.doc;
        switch (changes.type) {
          case DocumentChangeType.added:
            _users[uid] = dataDocs.data()!;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid]!.addAll(dataDocs.data()!);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _unSubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      }
    });
  }

 void _subscribeToOrders(String uid) {
    _firestore.collection('users').doc(uid).collection('orders')
        .snapshots().listen((orders) async {
          int numOrders = orders.docs.length;

          double money = 0.0;
          for(DocumentSnapshot d in orders.docs) {
            DocumentSnapshot order = await _firestore.collection('orders').doc(d.id)
                .get();

            if (order.data() == null) {
              continue;
            }

            Map<String, dynamic> data = order.data() as Map<String, dynamic>;

            money = money + data['totalPrice'];
          }

          _users[uid]!.addAll({
            'money': money,
            'orders': numOrders
          });


          _usersController.add(_users.values.toList());
    });
 }

 void _unSubscribeToOrders(String uid) {
    _users[uid]!['subscription'].cancel();
 }

}