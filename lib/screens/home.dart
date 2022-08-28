import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/database_usage.dart';
import '../widgets/listview_tile.dart';
import '../models/my_user.dart';
import '../widgets/upcoming_schedule_card.dart';

class HomeScreen extends StatefulWidget {
  final MyUser usr;

  HomeScreen({Key? key, required this.usr}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String toggled = 'All';
  String searchField = '';

  void changeToggled(String str) {
    setState(() {
      toggled = str;
    });
  }

  void changeText(String str) {
    setState(() {
      searchField = str;
    });
  }

  void dummyFunction() {
  }

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
      borderSide: BorderSide.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Text("Hello, ${widget.usr.firstName}! 👋"),
          ),
          leading: GestureDetector(
            child: Icon(
              Icons.menu,
            ),
            onTap: () {},
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Icon(
                    Icons.logout,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        backgroundColor: Color(0xff201c24),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: TextFormField(
                      onChanged: (value) => changeText(value),
                      decoration: InputDecoration(
                        hintText: "Search a doctor or health issue",
                        hintStyle:
                        TextStyle(fontSize: 16.0, color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xff282434),
                        border: outlineInputBorder,
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "   Upcoming Schedule",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              UpcomingSchedulePremadeTile(),
              SizedBox(height: 7.9),
              Text(
                "  Talk to a Dcotor",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Text(
                "    Get medical advice, prescriptions,\n    tests, and referrals",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListViewTile(
                toggleFunction: changeToggled,
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width - 40,
                    child: DatabaseUsage(
                      buttonStatus: toggled,
                      searchField: searchField,
                      isAdminEdit: false,
                      fun: dummyFunction,
                      deleteFun: dummyFunction,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff1c242c),
          selectedItemColor: Colors.blue,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: '•',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: '•',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.wechat),
              label: '•',
            ),
            BottomNavigationBarItem(
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://imgur.com/h6nr62G.png",
                  cacheHeight: 25,
                  cacheWidth: 25,
                ),
              ),
              label: '•',
            ),
          ],
        ));
  }
}