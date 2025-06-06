import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';




class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<QuerySnapshot<Map<String, dynamic>>> _carregaDados() async {
    return await FirebaseFirestore.instance.collection('home').orderBy('pos').get();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
       decoration: BoxDecoration(
         gradient: LinearGradient(
             colors: [
                Color.fromARGB(255, 211, 118, 130),
               Color.fromARGB(255, 253, 181, 168),
             ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
         ),
       ),
    );
    return Stack(
        children: [
          _buildBodyBack(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Novidades'),
                  centerTitle: true,
                ),
                centerTitle: true,
              ),
              SliverFillRemaining(
                child: FutureBuilder<QuerySnapshot>(
                  future: _carregaDados(),
                  builder:  (context, snapshot) {
                     if (!snapshot.hasData) {
                       return Container(
                         height: 100,
                         alignment: Alignment.center,
                         child: CircularProgressIndicator(
                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                         ),
                       );
                     }
                     else  {
                       List<Map<String, dynamic>> documents =
                            snapshot.data!.docs.map((DocumentSnapshot doc) {
                             return doc.data()! as Map<String, dynamic>;
                           }).toList().cast();
                         return StaggeredGrid.count(
                           crossAxisCount: 2,
                           mainAxisSpacing: 1.0,
                           crossAxisSpacing: 2.0,
                           children: documents.map(
                               (doc) {
                                 return StaggeredGridTile.count(
                                   crossAxisCellCount: doc['x'],
                                   mainAxisCellCount: doc['y'],
                                   child: FadeInImage.memoryNetwork(
                                     placeholder: kTransparentImage,
                                     image: doc['image'],
                                     fit: BoxFit.cover,
                                   ),
                                 );
                               }
                           ).toList(),
                         );
                     }
                  },
                ) ,
              ),
            ],
          ),
        ],
    );
  }
}

