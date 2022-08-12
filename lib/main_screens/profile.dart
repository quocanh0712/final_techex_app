import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
            Color.fromARGB(255, 31, 129, 117),
            Colors.yellow
          ]))),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                expandedHeight: 140,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        child: const Text('Account',
                            style: TextStyle(color: Colors.black)),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 31, 129, 117),
                          Colors.yellow
                        ])),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, left: 30),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('images/profile/image0.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text('guest'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30)),
                            ),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text('Cart',
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 20)),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text('Orders',
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 20)),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text('WishList',
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 20)),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ProfileHeaderLable(
                      headerLable: '  Account Info  ',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 260,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: const [
                            RepeatedListTile(
                              title: 'Email Address',
                              subTitle: 'example@gmail.com',
                              icon: Icons.email,
                            ),
                            LightGreenDivider(),
                            RepeatedListTile(
                              title: 'Phone Number',
                              subTitle: '(+84) 111 111 111',
                              icon: Icons.phone,
                            ),
                            LightGreenDivider(),
                            RepeatedListTile(
                              title: 'Address',
                              subTitle:
                                  'example: 58 Hai Ho ,Tan Chinh ,Hai Chau - Da Nang',
                              icon: Icons.location_city,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const ProfileHeaderLable(
                        headerLable: '  Account Settings  '),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 260,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            RepeatedListTile(
                              title: 'Edit Profile',
                              subTitle: '',
                              icon: Icons.edit,
                              onPressed: () {},
                            ),
                            const LightGreenDivider(),
                            RepeatedListTile(
                              title: 'Change Password',
                              icon: Icons.lock_clock_sharp,
                              onPressed: () {},
                            ),
                            const LightGreenDivider(),
                            RepeatedListTile(
                              title: 'Logout',
                              icon: Icons.logout,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/welcome_screen');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LightGreenDivider extends StatelessWidget {
  const LightGreenDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.lightGreen,
        thickness: 2,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile(
      {Key? key,
      required this.title,
      this.subTitle = '',
      required this.icon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLable extends StatelessWidget {
  final String headerLable;
  const ProfileHeaderLable({Key? key, required this.headerLable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              )),
          Text(headerLable,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
              height: 40,
              width: 50,
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              )),
        ],
      ),
    );
  }
}
