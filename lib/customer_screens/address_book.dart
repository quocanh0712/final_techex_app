import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_techex_app/customer_screens/add_address.dart';
import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:final_techex_app/widgets/button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({Key? key}) : super(key: key);

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();

  Future dfAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(item.id);
      transaction.update(documentReference, {'default': false});
    });
  }

  Future dfAddressTrue(dynamic customerInfor) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(customerInfor['addressid']);
      transaction.update(documentReference, {'default': true});
    });
  }

  Future updateProfile(dynamic customerInfor) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'address':
            '${customerInfor['country']} - ${customerInfor['state']} - ${customerInfor['city']}',
        'phone': customerInfor['phone']
      });
    });
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait..', progressBgColor: Colors.red);
  }

  /*void hideProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.close();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 31, 129, 117),
        leading: const AppBarBackButton(),
        title: const AppBarTitle(
          title: 'Address Book',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: addressStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      'You Don\'t have set \n\n an address yet !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ));
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var customerInfor = snapshot.data!.docs[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async =>
                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                            DocumentReference docReference = FirebaseFirestore
                                .instance
                                .collection('customers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('address')
                                .doc(customerInfor['addressid']);
                            transaction.delete(docReference);
                          }),
                          child: GestureDetector(
                            onTap: () async {
                              showProgress();
                              for (var item in snapshot.data!.docs) {
                                await dfAddressFalse(item);
                              }
                              await dfAddressTrue(customerInfor).whenComplete(
                                  () => updateProfile(customerInfor));
                              Future.delayed(const Duration(microseconds: 100))
                                  .whenComplete(() => Navigator.pop(context));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: customerInfor['default'] == true
                                    ? Colors.white
                                    : Colors.yellow.shade200,
                                child: ListTile(
                                  trailing: customerInfor['default'] == true
                                      ? const Icon(Icons.home,
                                          color: Colors.green)
                                      : const SizedBox(),
                                  title: SizedBox(
                                    height: 50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${customerInfor['firstname']} ${customerInfor['lastname']} '),
                                        Text(customerInfor['phone'])
                                      ],
                                    ),
                                  ),
                                  subtitle: SizedBox(
                                    height: 70,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'City/State: ${customerInfor['city']} - ${customerInfor['state']} '),
                                        Text(
                                            'Country: ${customerInfor['country']} ')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
            Button2(
                label: 'Add New Address',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddAddress()));
                },
                width: 0.8,
                buttonColor: Colors.black)
          ],
        ),
      ),
    );
  }
}
