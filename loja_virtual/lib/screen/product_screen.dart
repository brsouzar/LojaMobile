import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/card_model.dart';

import '../models/user_model.dart';
import 'card_screen.dart';
import 'login_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen(this.product, {super.key});
  
  final ProductData product;
  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  
  final ProductData? product;
  String? size;
   _ProductScreenState(this.product);
  
  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Camiseta branca'),
        centerTitle: true,
        
      ),
      body:ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider.builder(
                unlimitedMode: true,
                slideTransform: StackTransform(),
                initialPage: 0,
                enableAutoSlider: false,
                slideIndicator: CircularSlideIndicator(
                  padding: EdgeInsets.all(20),
                  indicatorBorderColor: Colors.white,
                  indicatorBackgroundColor: primaryColor,
                ),
                itemCount: product!.images!.length,
                slideBuilder: (index) {
                  final imagesUrl  = product!.images![index];
                  if (imagesUrl == null) {
                    return Text('Image nao encontrada');
                  }
                  else {
                    return Image.network(product!.images![index], fit: BoxFit.cover,);
                  }
                }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(product!.title!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text('R\$ ${product!.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text('Tamanho',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5,
                    ),
                    children: product!.sizes!.map(
                        (s) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                  color: s == size ? primaryColor : Colors.grey[500]!,
                                  width: 3.0
                                ),
                              ),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(s),
                            ),
                          );
                        }
                    ).toList(),
                  ),
                ),
                SizedBox(height: 30.0,),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                             backgroundColor :primaryColor,
                             shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                               ),
                    textStyle: TextStyle(color: Colors.white),
                  ),
                 onPressed: size != null ?
                     () {
                       if (UserModel.of(context).isLoggedIn()) {
                         CardProduct cardProduct = CardProduct();
                         cardProduct.size = size;
                         cardProduct.quantity = 1;
                         cardProduct.pid = product!.id;
                         cardProduct.category = product!.category;
                         cardProduct.productdata = product;

                         CardModel.of(context).addCardItem(cardProduct);
                         Navigator.of(context).push(
                             MaterialPageRoute(builder: (context)=> CardScreen())
                         );
                       }
                       else {
                         Navigator.of(context).push(
                           MaterialPageRoute(builder: (context)=> LoginScreen())
                         );
                       }
                   } : null,
                 child: Text(UserModel.of(context).isLoggedIn() ? 'Adicionar ao Carrinho' : 'Entre para comprar',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                 ),
                  ),
                ),
                SizedBox(height: 30.0,),
                Text('Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(product!.description!,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
