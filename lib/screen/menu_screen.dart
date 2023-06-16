import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

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
          Container(
            padding: const EdgeInsets.fromLTRB(
                Util.mainPadding, Util.mainPadding, Util.mainPadding, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
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
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            ),
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
          return Card(
              shadowColor: Colors.blue,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Image.asset('assets/group.png'),
                title: const Text(
                  'Steak',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                subtitle: const Text(
                  '\$120',
                  style: TextStyle(fontSize: 12.0),
                ),
              ));
        });
  }
}
