import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../custom_widgets/custom_icon_button.dart';

class ProfileScoreWidget extends StatelessWidget {
  const ProfileScoreWidget({required this.user, Key? key}) : super(key: key);
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width;
    final double boxWidth = (totalWidth / 4) - 14;
    return Builder(
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomIconButton(
              height: boxWidth - 10,
              width: boxWidth,
              icon: Icons.account_balance,
              onTap: () {
                // TODO: on wallet click
              },
            ),
            _CustomScoreButton(
              score: '123',
              title: 'Posts',
              height: boxWidth - 10,
              width: boxWidth,
              onTap: () {
                // TODO: on Posts click
              },
            ),
            _CustomScoreButton(
              score: user.supporting?.length.toString() ?? '0',
              title: 'Supporting',
              height: boxWidth - 10,
              width: boxWidth,
              onTap: () {
                // UserBottomSheets().showUsersBottomSheet(
                //   context: context,
                //   title: 'Supporting',
                //   showBackButton: false,
                //   users: provider.supportings(uid: AuthMethods.uid),
                // );
              },
            ),
            _CustomScoreButton(
              score: user.supporters?.length.toString() ?? '0',
              title: 'Supporters',
              height: boxWidth - 10,
              width: boxWidth,
              onTap: () {
                // UserBottomSheets().showUsersBottomSheet(
                //   context: context,
                //   title: 'Supporters',
                //   showBackButton: false,
                //   users: provider.supporters(uid: AuthMethods.uid),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomScoreButton extends StatelessWidget {
  const _CustomScoreButton({
    required this.onTap,
    required this.height,
    required this.width,
    required this.score,
    required this.title,
    // ignore: unused_element
    this.borderRadius,
    Key? key,
  }) : super(key: key);
  final VoidCallback onTap;
  final double height;
  final double width;
  final String score;
  final String title;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                score,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
