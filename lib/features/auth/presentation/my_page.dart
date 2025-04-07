import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final token = authState['token'];
    final role = authState['role'];

    String loginId = "";
    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        loginId = decodedToken['sub'] ?? "";
      } catch (e) {
        loginId = "토큰 오류";
      }
    }

    return Center(
      child: ListView(
        children: [
          Text(
            '이름 : $loginId',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
              'headline1',
            style: AppTypography.headline1
          ),
          Text(
              'headline2',
              style: AppTypography.headline2
          ),
          Text(
              'headline3',
              style: AppTypography.headline3
          ),
          Text(
              'headline4',
              style: AppTypography.headline4
          ),
          Text(
              'headline5',
              style: AppTypography.headline5
          ),
          Text(
              'headline6',
              style: AppTypography.headline6
          ),
          Text(
              'body1',
              style: AppTypography.body1
          ),
          Text(
              'body2',
              style: AppTypography.body2
          ),
          Text(
              'body3',
              style: AppTypography.body3
          ),
          Text(
              'buttonLabelXSmall',
              style: AppTypography.buttonLabelXSmall
          ),
          Text(
              'buttonLabelSmall',
              style: AppTypography.buttonLabelSmall
          ),
          Text(
              'buttonLabelMedium',
              style: AppTypography.buttonLabelMedium
          ),
          Text(
              'buttonLabelNormal',
              style: AppTypography.buttonLabelNormal
          ),
          Text(
              'buttonLabelNormal',
              style: AppTypography.buttonLabelNormal
          ),
          Text(
              'primary_050',
              style: AppTypography.body1.copyWith(color: AppColors.primary_050)
          ),
          Text(
              'primary_150',
              style: AppTypography.body1.copyWith(color: AppColors.primary_150)
          ),
          Text(
              'primary_250',
              style: AppTypography.body1.copyWith(color: AppColors.primary_250)
          ),
          Text(
              'primary_350',
              style: AppTypography.body1.copyWith(color: AppColors.primary_350)
          ),
          Text(
              'primary_450',
              style: AppTypography.body1.copyWith(color: AppColors.primary_450)
          ),
          Text(
              'primary_550',
              style: AppTypography.body1.copyWith(color: AppColors.primary_550)
          ),
          Text(
              'primary_650',
              style: AppTypography.body1.copyWith(color: AppColors.primary_650)
          ),
          Text(
              'primary_750',
              style: AppTypography.body1.copyWith(color: AppColors.primary_750)
          ),
          Text(
              'primary_850',
              style: AppTypography.body1.copyWith(color: AppColors.primary_850)
          ),
          Text(
              'primary_950',
              style: AppTypography.body1.copyWith(color: AppColors.primary_950)
          ),
          Text(
              'grayScale_150',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_150)
          ),
          Text(
              'grayScale_250',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_250)
          ),
          Text(
              'grayScale_350',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_350)
          ),
          Text(
              'grayScale_450',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_450)
          ),
          Text(
              'grayScale_550',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_550)
          ),
          Text(
              'grayScale_650',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_650)
          ),
          Text(
              'grayScale_750',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_750)
          ),
          Text(
              'grayScale_850',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_850)
          ),
          Text(
              'grayScale_950',
              style: AppTypography.body1.copyWith(color: AppColors.grayScale_950)
          ),
          Text(
              'red',
              style: AppTypography.body1.copyWith(color: AppColors.red)
          ),
          Text(
              'yellow',
              style: AppTypography.body1.copyWith(color: AppColors.yellow)
          ),
          Text(
              'deepYellow',
              style: AppTypography.body1.copyWith(color: AppColors.deepYellow)
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
