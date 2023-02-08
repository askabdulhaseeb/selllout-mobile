import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../models/app_user.dart';
import '../../providers/user/user_provider.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_profile_image.dart';

class SearchUserScreen extends StatelessWidget {
  const SearchUserScreen({super.key});
  static const String routeName = '/search-user-screen';
  @override
  Widget build(BuildContext context) {
    final UserProvider userPro = Provider.of<UserProvider>(context);
    final AppUser me = userPro.user(uid: AuthMethods.uid);
    final BorderRadius borderRadius = BorderRadius.circular(4);
    final Border border = Border.all(
      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
    );
    final TextStyle textStyle = TextStyle(
      color: Theme.of(context).textTheme.bodyLarge!.color!,
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          prefixIcon: const Icon(CupertinoIcons.search),
          onChanged: (String? value) => userPro.onSearch(value),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider userPro, _) {
            final List<AppUser> users = userPro.filterProduct();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final AppUser user = users[index];
                final bool reqSended = user.isPublicProfile
                    ? false
                    : (user.supportRequest?.contains(me.uid) ?? false)
                        ? true
                        : false;
                final bool isSupporter =
                    user.supporters?.contains(me.uid) ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: <Widget>[
                      CustomProfileImage(imageURL: user.imageURL ?? ''),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          user.displayName ?? 'null',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      CustomElevatedButton(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(7.5),
                        borderRadius: BorderRadius.circular(12),
                        bgColor: isSupporter ? Colors.transparent : null,
                        border: isSupporter ? border : null,
                        textStyle: isSupporter ? textStyle : null,
                        title: isSupporter
                            ? 'Supporting'
                            : ((!user.isPublicProfile) && reqSended)
                                ? 'Request Sended'
                                : (me.supporters?.contains(user.uid) ?? false)
                                    ? 'Support Back'
                                    : 'Support',
                        onTap: () async {
                          if (user.isPublicProfile) {
                            await userPro.support(uid: user.uid);
                          } else {
                            await userPro.supportRequrest(uid: user.uid);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
