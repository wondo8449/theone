import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/features/invitation/presentation/invitation_page.dart';
import 'package:theone/features/tree/presentation/tree_page.dart';
import 'package:theone/widgets/custom_bottom_navigation_bar.dart';
import 'package:theone/widgets/main_header.dart';

import '../features/auth/presentation/my_page.dart';
import '../features/sharing/presentation/sharing_page.dart';

class StackPage extends ConsumerStatefulWidget {
  final int initialIndex;

  const StackPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<StackPage> createState() => _StackPageState();
}

class _StackPageState extends ConsumerState<StackPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Column(
              children: [
                SizedBox(height: statusBarHeight),
                MainHeader(selectedIndex: _selectedIndex),
              ],
            ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            SharingPage(),
            InvitationPage(),

            TreePage(),
            MyPage(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            context: context,
            ref: ref),
      ),
    );
  }
}