import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/auth/data/auth_api.dart';
import 'package:url_launcher/url_launcher.dart';
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
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    if (await canLaunchUrl(Uri.parse(privacyPolicyUrl))) {
      await launchUrl(Uri.parse(privacyPolicyUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('개인정보 처리방침을 열 수 없습니다.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Text(
          '개인정보 이용 동의',
          style: AppTypography.headline3.copyWith(color: AppColors.color2),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color6.withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        size: 48,
                        color: AppColors.color4,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        '개인정보 처리방침',
                        style: AppTypography.headline4.copyWith(
                          color: AppColors.color2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      '이 앱을 이용함에 있어, 아래와 같이 개인정보를 수집 및 이용합니다.',
                      style: AppTypography.body1.copyWith(
                        color: AppColors.color2,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20),

                    _buildSection(
                      '1. 교회에서 요청하는 개인정보 항목',
                      '- 이름',
                    ),
                    SizedBox(height: 16),

                    _buildSection(
                      '2. 이용 목적',
                      '- 교회의 서비스 이용에 필요한 이용자 본인 확인 여부\n- 교회의 서비스 이용에 필요한 정보 전달',
                    ),
                    SizedBox(height: 16),

                    _buildSection(
                      '3. 개인정보의 보유 및 이용 기간',
                      '개인정보보호법 58조 4항에 의거 "종교단체가 선교등 고유 목적을 달성하기 위하여 수집, 이용하는 개인정보"는 개인정보보호법 예외 조항에 해당됩니다. 정보 수집 및 이용을 원치 않는 분은 교회로 신청하시기 바랍니다',
                    ),
                    SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.color5,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '본인은 상기 내용을 숙지하였으며 이에 동의합니다.\n* 미동의 시 서비스 이용이 불가합니다.',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.color2,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color6.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: _launchPrivacyPolicy,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text(
                        '개인정보 처리방침 자세히 보기',
                        style: AppTypography.buttonLabelMedium.copyWith(
                          color: AppColors.color4,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Divider(color: AppColors.color5, height: 1),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: _handleAccept,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '동의하고 시작하기',
                          style: AppTypography.buttonLabelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headline6.copyWith(
            color: AppColors.color2,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.color5,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: AppTypography.body2.copyWith(
              color: AppColors.color3,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}