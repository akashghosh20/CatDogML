import 'package:catvsdog/Cat&DogRecog.dart';
import 'package:catvsdog/FlowersRecog.dart';
import 'package:catvsdog/FruitsRecog.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Deep Learning Projects"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Card(
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatandDogRecog(),
                      ),
                    );
                  },
                  leading: Icon(Icons.pets, color: Colors.blue),
                  title: Text(
                    "Cat and Dog Detection",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Card(
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlowersRecog(),
                      ),
                    );
                  },
                  leading: Icon(Icons.nature, color: Colors.green),
                  title: Text(
                    "Flower Detection",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Card(
                elevation: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FruitsRecog(),
                      ),
                    );
                  },
                  leading: Icon(Icons.free_breakfast, color: Colors.green),
                  title: Text(
                    "Fruits and vegetables Detection",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
