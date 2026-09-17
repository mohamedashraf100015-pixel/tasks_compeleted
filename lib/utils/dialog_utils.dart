import 'package:flutter/material.dart';
import 'package:tasks_compeleted/utils/app_styles.dart';
import 'package:tasks_compeleted/utils/size_utils.dart';

import 'app_colors.dart';

class DialogUtils {
  static void showLoading({
    required BuildContext context,
    required String loadingText,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: SizeConfig.width(context) * .04,
            children: [
              CircularProgressIndicator(color: AppColors.mainLightColor),
              Text(loadingText, style: AppStyles.semi16MainLightColor),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String? title = '',
    String? positiveActionName,
    VoidCallback? positiveAction,
    String? negativeActionName,
    VoidCallback? negativeAction,
  }) {
    List<Widget> actions = [];
    if (positiveActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            positiveAction?.call();

          },
          child: Text(
            positiveActionName,
            style: AppStyles.semi16MainLightColor,
          ),
        ),
      );
    }
    if (negativeActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            negativeAction?.call();
          },
          child: Text(
            negativeActionName,
            style: AppStyles.semi16MainLightColor,
          ),
        ),
      );
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message, style: AppStyles.semi16MainLightColor),
          title: Text(title!, style: AppStyles.semi16MainLightColor),
          actions: actions,
        );
      },
    );
  }
}
