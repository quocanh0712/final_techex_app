import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SmartWatchGalleryScreen extends StatefulWidget {
  const SmartWatchGalleryScreen({Key? key}) : super(key: key);

  @override
  State<SmartWatchGalleryScreen> createState() =>
      _SmartWatchGalleryScreenState();
}

class _SmartWatchGalleryScreenState extends State<SmartWatchGalleryScreen> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincategory', isEqualTo: 'Smart watch')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            'This category \n has no items yet !',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ));
        }

        return SingleChildScrollView(
          child: StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 2,
              itemBuilder: ((context, index) {
                return ProductModel(
                  products: snapshot.data!.docs[index],
                );
              }),
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
        );

        /*ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              leading: Image(
                image: NetworkImage(data['productimages'][0]),
              ),
              title: Text(data['productname']),
              subtitle: Text(data['price'].toString()),
            );
          }).toList(),
        ); */
      },
    );
  }
}
