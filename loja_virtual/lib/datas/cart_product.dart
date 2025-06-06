import 'package:loja_virtual/datas/product_data.dart';

class CardProduct {

  String? cid;
  String? category;
  String? pid;
  int? quantity;
  String? size;

  ProductData? productdata;
  CardProduct();

   CardProduct.fromJson(Map<String, dynamic> data) {
      cid = data['id'];
      category = data['category'];
      pid = data['pid'];
      quantity = data['quantity'];
   }

  Map<String, dynamic> toMap() {
     return {
       'category': category,
       'pid': pid,
       'quantity': quantity,
       'size': size,
       'product': productdata!.toResumedMap(),
     };
  }
}