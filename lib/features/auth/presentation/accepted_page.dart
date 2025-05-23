import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/auth/data/auth_api.dart';
import 'package:url_launcher/url_launcher.dart'; // ← 추가

import '../../../core/constants/app_border_radius.dart';

class AcceptedPage extends ConsumerStatefulWidget {
  @override
  _AcceptedPageState createState() => _AcceptedPageState();
}

class _AcceptedPageState extends ConsumerState<AcceptedPage> {
  final String privacyPolicyUrl = 'https://www.freeprivacypolicy.com/live/fab30227-c3cc-4266-b99d-2836bfff83c6';

  Future<void> _handleAccept() async {
    final authApi = ref.read(authApiProvider);
    final authNotifier = ref.read(authProvider.notifier);

    try {
      await authApi.accept();
      await authNotifier.accept();

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('개인정보 활용 동의 실패'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    if (await canLaunchUrl(Uri.parse(privacyPolicyUrl))) {
      await launchUrl(Uri.parse(privacyPolicyUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('개인정보 처리방침을 열 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보 이용 동의', style: AppTypography.headline3.copyWith(color: AppColors.grayScale_950)),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.medium16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text('이 앱을 이용함에 있어, 아래와 같이 개인정보를 수집 및 이용합니다.'),
            SizedBox(height: 20),
            Text('1. 교회에서 요청하는 개인정보 항목', style: AppTypography.headline6),
            SizedBox(height: 4),
            Text('- 이름'),
            SizedBox(height: 20),
            Text('2. 이용 목적', style: AppTypography.headline6),
            SizedBox(height: 4),
            Text('- 교회의 서비스 이용에 필요한 이용자 본인 확인 여부 \n- 교회의 서비스 이용에 필요한 정보 전달'),
            SizedBox(height: 20),
            Text('3. 개인정보의 보유 및 이용 기간', style: AppTypography.headline6),
            SizedBox(height: 4),
            Text(
              '개인정보보호법 58조 4항에 의거 "종교단체가 선교등 고유 목적을 달성하기 위하여 수집, 이용하는 개인정보"는 개인정보보호법 예외 조항에 해당됩니다. 정보 수집 및 이용을 원치 않는 분은 교회로 신청하시기 바랍니다',
            ),
            SizedBox(height: 20),
            Text(
              '본인은 상기 내용을 숙지하였으며 이에 동의합니다. \n* 미동의 시 서비스 이용이 불가합니다.',
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: _launchPrivacyPolicy,
                child: Text(
                  '개인정보 처리방침 보기',
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: _handleAccept,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_450),
                  minimumSize: WidgetStateProperty.all<Size>(Size(80, 40)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                  ),
                ),
                child: Text('동의', style: AppTypography.buttonLabelMedium.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
