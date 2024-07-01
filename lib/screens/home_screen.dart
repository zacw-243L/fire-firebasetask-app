import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference storesCollection =
      FirebaseFirestore.instance.collection('stores');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          auth.signOut();
        },
        child: const Icon(Icons.logout),
      ),
      appBar: AppBar(title: Text('Stores')),
      body: StreamBuilder<QuerySnapshot>(
        stream: storesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(doc['store']),
                  subtitle: Text(doc['location']),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      /* body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Add this line
          children: [
            Center(
                child: Text(
                    'Hello ${auth.currentUser?.displayName}')), // Wrap with Center
            SizedBox(
                height: 20), // Add some space between the text and the button
            Center(
                child: ElevatedButton(
              // Wrap with Center
              onPressed: () async {
                await storesCollection.add({
                  'store': 'Tech Haven',
                  'location': '#A2-15',
                  'category': 'Electronics',
                });
                await storesCollection.add({
                  'store': 'Style Hub',
                  'location': '#B3-09',
                  'category': 'Fashion',
                });
                await storesCollection.add({
                  'store': 'Gourmet Delights',
                  'location': '#C1-12',
                  'category': 'Dining',
                });
                await storesCollection.add({
                  'store': 'Book Nook',
                  'location': '#D4-22',
                  'category': 'Books',
                });
                await storesCollection.add({
                  'store': 'Fitness World',
                  'location': '#E3-18',
                  'category': 'Sports',
                });
              },
              child: const Text('Add'),
            )),
            FutureBuilder<QuerySnapshot>(
              future: storesCollection.get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    // snapshot.data!.docs is of type List <DocumentSnapshot>
                    print(doc['store']);
                  }
                  return Container();
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),*/
    );
  }
}
