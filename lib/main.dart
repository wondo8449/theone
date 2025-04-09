import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/features/auth/presentation/accepted_page.dart';
import 'package:theone/features/auth/presentation/my_page.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/auth/presentation/login_page.dart';
import 'package:theone/features/sharing/presentation/QT_sharing_detail_page.dart';
import 'package:theone/features/sharing/presentation/QT_write_page.dart';
import 'package:theone/features/sharing/presentation/invitation_sharing_detail_page.dart';
import 'package:theone/features/sharing/presentation/invitation_write_page.dart';
import 'package:theone/theme.dart';
import 'package:theone/widgets/stack_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    )
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final token = authState['token'];
    final isAccepted = authState['isAccepted'];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: token == null || token.isEmpty
          ? LoginPage()
          : isAccepted == "false"
          ? AcceptedPage()
          : StackPage(initialIndex: 0),
      routes: {
        '/login' : (context) => LoginPage(),
        '/accepted': (context) => AcceptedPage(),
        '/mypage': (context) => MyPage(),
        '/QTwrite': (context) => QTWritePage(),
        '/invitationWrite': (context) => InvitationWritePage(),
        '/InvitationSharingDetail': (context) => InvitationSharingDetailPage(),
        '/QTSharingdetail': (context) => QTSharingDetailPage()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const StackPage(),
        );
      },
    );
  }
}

