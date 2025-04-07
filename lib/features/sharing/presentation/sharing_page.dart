import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theone/core/constants/app_colors.dart';
import 'package:theone/core/constants/app_spacing.dart';
import 'package:theone/core/constants/app_typography.dart';

import '../../../core/constants/app_border_radius.dart';

class SharingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: Padding(
          padding: AppSpacing.medium16,
          child: ListView(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_150),
                        minimumSize: WidgetStateProperty.all<Size>(Size(100, 35)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                        )),
                      child: Text('+ QT 나눔 쓰기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.primary_450))),
                  SizedBox(width: 16),
                  TextButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary_150),
                          minimumSize: WidgetStateProperty.all<Size>(Size(100, 35)),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                          )),
                      child: Text('+ 풍삶초 나눔 쓰기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.primary_450))),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text('QT 나눔', style: AppTypography.headline4),
                     TextButton(
                         onPressed: () {

                         },
                         style: ButtonStyle(
                             minimumSize: WidgetStateProperty.all<Size>(Size(30, 20)),
                             shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                             )),
                         child: Text('+ 더보기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.grayScale_850))),
                   ],
                  ),
                  Card(
                    color: Colors.white,
                    margin: AppSpacing.small4,
                    child: Padding(
                        padding: AppSpacing.small12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('하늘의 것을 지혜롭게 사용해라', style: AppTypography.headline6,),
                                Text('4월 7일 김예찬', style: AppTypography.body2,)
                              ],
                            ),
                            Text('QT 나눔 내용입니다. \n QT 나눔 내용입니다. \n QT 나눔 내용입니다.', style: AppTypography.body3)
                          ],
                        ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: AppSpacing.small4,
                    child: Padding(
                      padding: AppSpacing.small12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('하늘의 것을 지혜롭게 사용해라', style: AppTypography.headline6,),
                              Text('4월 7일 김예찬', style: AppTypography.body2,)
                            ],
                          ),
                          Text('QT 나눔 내용입니다. \n QT 나눔 내용입니다. \n QT 나눔 내용입니다.', style: AppTypography.body3)
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: AppSpacing.small4,
                    child: Padding(
                      padding: AppSpacing.small12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('하늘의 것을 지혜롭게 사용해라', style: AppTypography.headline6,),
                              Text('4월 7일 김예찬', style: AppTypography.body2,)
                            ],
                          ),
                          Text('QT 나눔 내용입니다. \n QT 나눔 내용입니다. \n QT 나눔 내용입니다.', style: AppTypography.body3)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('풍삶초 나눔', style: AppTypography.headline4),
                      TextButton(
                          onPressed: () {

                          },
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(Size(30, 20)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: AppBorderRadius.medium16),
                              )),
                          child: Text('+ 더보기', style: AppTypography.buttonLabelSmall.copyWith(color: AppColors.grayScale_850))),
                    ],
                  ),
                  Card(
                    color: Colors.white,
                    margin: AppSpacing.small4,
                    child: Padding(
                      padding: AppSpacing.small12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('하늘의 것을 지혜롭게 사용해라', style: AppTypography.headline6,),
                              Text('4월 7일 김예찬', style: AppTypography.body2,)
                            ],
                          ),
                          Text('QT 나눔 내용입니다. \n QT 나눔 내용입니다. \n QT 나눔 내용입니다.', style: AppTypography.body3)
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: AppSpacing.small4,
                    child: Padding(
                      padding: AppSpacing.small12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('하늘의 것을 지혜롭게 사용해라', style: AppTypography.headline6,),
                              Text('4월 7일 김예찬', style: AppTypography.body2,)
                            ],
                          ),
                          Text('QT 나눔 내용입니다. \n QT 나눔 내용입니다. \n QT 나눔 내용입니다.', style: AppTypography.body3)
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: AppSpacing.small4,
                    child: Padding(
                      padding: AppSpacing.small12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('하늘의 것을 지혜롭게 사용해라', style: AppTypography.headline6,),
                              Text('4월 7일 김예찬', style: AppTypography.body2,)
                            ],
                          ),
                          Text('QT 나눔 내용입니다. \n QT 나눔 내용입니다. \n QT 나눔 내용입니다.', style: AppTypography.body3)
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
      )
    );
  }
}
