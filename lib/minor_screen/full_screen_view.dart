import 'package:final_techex_app/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({Key? key, required this.imagesList}) : super(key: key);

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 31, 129, 117),
        leading: AppBarBackButton(),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  ('${index + 1}') +
                      ('/') +
                      (widget.imagesList.length.toString()),
                  style: TextStyle(fontSize: 24, letterSpacing: 8),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView(
                onPageChanged: ((value) {
                  setState(() {
                    index = value;
                  });
                }),
                controller: _controller,
                children: List.generate(widget.imagesList.length, (index) {
                  return InteractiveViewer(
                      transformationController: TransformationController(),
                      child:
                          Image.network(widget.imagesList[index].toString()));
                }),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: imageView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagesList.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              _controller.jumpToPage(index);
            },
            child: Container(
                margin: EdgeInsets.all(3),
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.red),
                    borderRadius: BorderRadius.circular(18)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imagesList[index],
                    fit: BoxFit.fill,
                  ),
                )),
          );
        }));
  }
}
