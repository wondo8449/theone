import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/features/auth/presentation/accepted_page.dart';
import 'package:theone/features/auth/presentation/my_page.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/auth/presentation/login_page.dart';
import 'package:theone/features/invitation/presentation/invitation_detail_page.dart';
import 'package:theone/features/invitation/presentation/invitation_register_page.dart';
import 'package:theone/features/sharing/presentation/QT_sharing_detail_page.dart';
import 'package:theone/features/sharing/presentation/QT_sharing_list_page.dart';
import 'package:theone/features/sharing/presentation/QT_write_page.dart';
import 'package:theone/features/sharing/presentation/invitation_sharing_detail_page.dart';
import 'package:theone/features/sharing/presentation/invitation_write_page.dart';
import 'package:theone/theme.dart';
import 'package:theone/widgets/stack_page.dart';
import 'features/sharing/presentation/invitation_sharing_list_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:theone/widgets//splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)), // 2초 스플래시
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SplashPage();
          }

          // 토큰 여부 및 승인 여부 판단
          if (token == null || token.isEmpty) {
            return LoginPage();
          } else if (isAccepted == "false") {
            return AcceptedPage();
          } else {
            return StackPage(initialIndex: 0);
          }
        },
      ),
      routes: {
        '/login' : (context) => LoginPage(),
        '/accepted': (context) => AcceptedPage(),
        '/mypage': (context) => MyPage(),
        '/invitationRegister': (context) => InvitationRegisterPage(),
        '/QTwrite': (context) => QTWritePage(),
        '/invitationWrite': (context) => InvitationWritePage(),
        '/invitationDetail': (context) => InvitationDetailPage(),
        '/InvitationSharingDetail': (context) => InvitationSharingDetailPage(),
        '/QTSharingdetail': (context) => QTSharingDetailPage(),
        '/QTSharingList': (context) => QTSharingListPage(),
        '/invitationSharingList': (context) => InvitationSharingListPage()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const StackPage(),
        );
      },
    );
  }
}


