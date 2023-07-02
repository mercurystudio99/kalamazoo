import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isSelectionMode = false;
  final int listLength = 30;
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: CustomColor.primaryColor.withOpacity(0.1),
                    blurRadius: 30.0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight:
                        Radius.circular(MediaQuery.of(context).size.width),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding * 0.5),
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
                      Util.fullMenu,
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
              Padding(
                padding: const EdgeInsets.only(
                    left: Util.mainPadding,
                    right: Util.mainPadding,
                    bottom: 20),
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  elevation: 8,
                  shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search Restaurant or Food...',
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 50,
                          minHeight: 2,
                        ),
                        prefixIcon: Icon(Icons.search_outlined, size: 24),
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (value!.contains('\n')) {}
                        return null;
                      }),
                ),
              ),
              Expanded(
                child: ListBuilder(
                  isSelectionMode: isSelectionMode,
                  selectedList: _selected,
                  onSelectionChange: (bool x) {
                    setState(() {
                      isSelectionMode = x;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<bool> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectedList.length,
        itemBuilder: (_, int index) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Card(
                  color: (widget.isSelectionMode
                      ? CustomColor.primaryColor
                      : Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    onTap: () {
                      NavigationRouter.switchToItem(context);
                    },
                    contentPadding: const EdgeInsets.all(8),
                    leading: Image.asset('assets/group.png'),
                    title: Text(
                      'Steak',
                      style: TextStyle(
                          color: (widget.isSelectionMode
                              ? Colors.white
                              : CustomColor.primaryColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    subtitle: Text(
                      '\$120',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12.0,
                          color: (widget.isSelectionMode
                              ? Colors.white
                              : Colors.black),
                          fontWeight: FontWeight.bold),
                    ),
                  )));
        });
  }
}
