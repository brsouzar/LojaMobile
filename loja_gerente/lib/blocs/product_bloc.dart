import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  ProductBloc(this.categoryId, this.product) : super(0) {
    if (product != null) {
       final dataProduct = Map.of(product!.data() as Map<String, dynamic>);
       unsavedData = dataProduct;
       unsavedData!['images'] = List.of(dataProduct['images']);
       unsavedData!['sizes'] = List.of(dataProduct['sizes']);
    } else {
      unsavedData = {
        'titulo': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': []
      };
    }
    _dataController.add(unsavedData!);
  }

  final _dataController = BehaviorSubject<Map>();
  Stream<Map> get outData => _dataController.stream;
  String categoryId;
  DocumentSnapshot? product;
  Map<String, dynamic>? unsavedData;


  @override
 void dispose() {
    _dataController.close();
  }
}