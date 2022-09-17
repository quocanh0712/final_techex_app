import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../widgets/appbar_widgets.dart';

class SubCategoryProducts extends StatefulWidget {
  final String subcategName;
  final String maincategName;
  const SubCategoryProducts(
      {Key? key, required this.subcategName, required this.maincategName})
      : super(key: key);

  @override
  State<SubCategoryProducts> createState() => _SubCategoryProductsState();
}

class _SubCategoryProductsState extends State<SubCategoryProducts> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincategory', isEqualTo: widget.maincategName)
        .where('subcategory', isEqualTo: widget.subcategName)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.grey.shade200.withOpacity(0.85),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: widget.subcategName),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
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
      ),
    );
  }
}
