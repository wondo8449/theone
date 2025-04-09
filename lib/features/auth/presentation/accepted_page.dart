import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_typography.dart';
import 'package:theone/features/auth/provider/auth_provider.dart';
import 'package:theone/features/auth/data/auth_api.dart';

class AcceptedPage extends ConsumerStatefulWidget {
  @override
  _AcceptedPageState createState() => _AcceptedPageState();
}

class _AcceptedPageState extends ConsumerState<AcceptedPage> {
  Future<void> _handleAccept() async {
    final authApi = ref.read(authApiProvider);


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('개인정보 이용 동의', style: AppTypography.headline5.copyWith(color: AppColors.primary_450)),
        TextButton(
            onPressed: _handleAccept,
            child: Text('동의')
        )
      ],
    );
  }

}