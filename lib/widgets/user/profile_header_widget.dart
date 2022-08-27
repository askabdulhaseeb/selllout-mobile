import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../models/app_user.dart';
import '../custom_widgets/custom_profile_image.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({required this.user, Key? key}) : super(key: key);
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width;
    const double imageRadius = 60;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomProfileImage(
            imageURL: user.imageURL ?? '',
            radius: imageRadius,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        user.displayName ?? 'null',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (user.uid == AuthMethods.uid)
                      InkWell(
                        onTap: () {
                          // Navigator.of(context)
                          //     .pushNamed(EditProfileScreen.routeName);
                        },
                        child: Text(
                          '- Edit',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
                const Text('Ratings: ....'),
                // TODO: Rating
                SizedBox(
                  width: totalWidth / 1.6,
                  child: user.bio == null || user.bio == ''
                      ? const Text('No Bio')
                      : Text(
                          user.bio!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
