import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Util.mainPadding * 0.5, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                NavigationRouter.back(context);
              },
            ),
            const Text(
              Util.termsTitle,
              style: TextStyle(
                color: CustomColor.primaryColor,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(
              width: Util.mainPadding,
            ),
          ],
        ),
      ),
    ];
    for (var element in Util.termsList) {
      list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
        child: Text(
          element['title'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ));
      list.add(Padding(
        padding: (element['title'].toString().isNotEmpty)
            ? const EdgeInsets.symmetric(horizontal: Util.mainPadding)
            : const EdgeInsets.only(
                left: Util.mainPadding * 2, right: Util.mainPadding),
        child: Text(
          element['description'],
          style: const TextStyle(fontSize: Util.descriptionSize),
        ),
      ));
      list.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
          child: SizedBox(height: 30)));
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/background.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          ListView(
            children: list,
          )
        ],
      ),
    );
  }
}
