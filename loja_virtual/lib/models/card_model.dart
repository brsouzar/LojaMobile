import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CardModel extends Model {

  UserModel user;
  List<CardProduct> products = [];
  bool isLoading = false;

  String? coupomCode;
  int discountPercentage = 0;


  CardModel(this.user){
    if (user.isLoggedIn()) _loadCardItems();
  }



  static CardModel of(BuildContext context) => ScopedModel.of<CardModel>(context);

  void addCardItem(CardProduct product) {
      products.add(product);
      FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
      .collection('cart').add(product.toMap()).then(
          (doc) {
               product.cid = doc.id;
      });
      notifyListeners();
  }

  void removeCardItem(CardProduct product) {
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
        .collection('cart').doc(product.cid).delete();

    products.remove(product);
    notifyListeners();
  }

  void decProduct(CardProduct cardProduct) {
    cardProduct.quantity = cardProduct.quantity! - 1;
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
    .collection('cart').doc(cardProduct.cid).update(cardProduct.toMap());

    notifyListeners();
  }
  void incProduct(CardProduct cardProduct) {
    cardProduct.quantity = cardProduct.quantity! + 1;
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
        .collection('cart').doc(cardProduct.cid).update(cardProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.coupomCode = couponCode!;
    this.discountPercentage = discountPercentage;
  }

  double getProductPrice() {
     double price  = 0.0;
     for(CardProduct c in products) {
       if (c.productdata != null) {
         price += c.quantity! * c.productdata!.price!;
       }
     }
     return price;
  }

  double getDiscount() {
      return getProductPrice() * discountPercentage / 100;
  }

  void updatePrice() {
    notifyListeners();
  }

  double getShipPrice() {
     return 9.99;
  }

  Future<String?> finishOrder() async {
     if (products.isEmpty) return null;

     isLoading = true;
     notifyListeners();

     double productPrice = getProductPrice();
     double ship = getShipPrice();
     double discount = getDiscount();

     DocumentReference refOrder = await FirebaseFirestore.instance.collection('orders').add({
       'clienteId': user.firebaseUser!.uid,
       'products': products.map((cardProduct)=> cardProduct.toMap()).toList(),
       'shipPrice': ship,
       'productsPrice': productPrice,
       'discount': discount,
       'totalPrice': productPrice - discount + ship,
       'status': 1
     });

     await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
       .collection('orders').doc(refOrder.id).set({
        'orderId': refOrder.id
       });
     QuerySnapshot query = await FirebaseFirestore.instance.collection('users')
     .doc(user.firebaseUser!.uid).collection('cart').get();

     for(DocumentSnapshot doc in query.docs) {
         doc.reference.delete();
     }
     products.clear();
     discountPercentage = 0;
     coupomCode = null;
     isLoading = false;

     notifyListeners();

     return refOrder.id;
  }

  void _loadCardItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser!.uid)
        .collection('cart').get();
    
    products = query.docs.map((doc) => CardProduct.fromJson(doc.data() as Map<String, dynamic>)).toList();
    notifyListeners();
  }

}