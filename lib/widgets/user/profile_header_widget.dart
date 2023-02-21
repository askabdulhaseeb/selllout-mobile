import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../models/app_user.dart';
import '../../screens/setting_screens/setting_screen.dart';
import '../../screens/user_screens/edit_profile_screen.dart';
import '../../utilities/app_image.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';
import '../custom_widgets/custom_profile_image.dart';
import '../custom_widgets/custom_rating_bar.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({required this.user, Key? key}) : super(key: key);
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width;
    const double imageRadius = 100;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CustomProfileImage(
                imageURL: user.imageURL ?? '',
                radius: imageRadius,
              ),
              const SizedBox(width: 10),
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
                        // if (user.uid == AuthMethods.uid)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<EditProfileScreen>(
                                    builder: (BuildContext context) =>
                                        EditProfileScreen(user: user)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(width: 20,child: Image.asset(AppImages.edit)),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Ratings: '),
                        CustomRatingBar(
                          initialRating: user.rating ?? 0,
                          onRatingUpdate: (_) {},
                        )
                      ],
                    ),
                    // TODO: Rating
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    user.bio == null || user.bio == ''
                        ?  Text('No Bio', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),)
                        : Text(
                            user.bio!,
                            maxLines: 1,
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              child: Align(
                alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> const SettingScreen()));
                      // Navigator.of(context)
                      //     .pushNamed(SettingScreen.routeName);
                    },
                      child: Icon(Icons.more_vert_outlined, color: Theme.of(context).hintColor)))),
        ],
      ),
    );
  }
}
