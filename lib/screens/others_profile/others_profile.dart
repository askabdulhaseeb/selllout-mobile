import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../functions/unique_id_functions.dart';
import '../../models/app_user.dart';
import '../../models/chat/chat.dart';
import '../../models/product/product.dart';
import '../../providers/product/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/product/grid_view_of_prod.dart';
import '../../widgets/user/private_account_widget.dart';
import '../../widgets/user/profile_header_widget.dart';
import '../../widgets/user/profile_score_widget.dart';
import '../chat_screens/personal_chat_page/personal_chat_screen.dart';

class OthersProfile extends StatelessWidget {
  const OthersProfile({required this.user, Key? key}) : super(key: key);
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final bool isSupporter =
        user.supporters?.contains(AuthMethods.uid) ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          user.username!,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (BuildContext context, ProductProvider prodPro, _) {
          final List<Product> prods = prodPro.userProducts(user.uid);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileHeaderWidget(user: user),
              ProfileScoreWidget(user: user, postLenth: prods.length),
              _SuppoertAndMessageButton(user: user),
              Expanded(
                child: (isSupporter || (user.isPublicProfile ?? false))
                    ? GridViewOfProducts(posts: prods)
                    : const SizedBox(
                        width: double.infinity,
                        child: PrivateAccountWidget(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuppoertAndMessageButton extends StatelessWidget {
  const _SuppoertAndMessageButton({required this.user, Key? key})
      : super(key: key);
  final AppUser user;
  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(4);
    final Border border = Border.all(
      color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1),
    );
    final TextStyle textStyle = TextStyle(
      color: Theme.of(context).textTheme.bodyText1!.color!,
      fontSize: 16,
    );
    return Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userPro, _) {
      // final AppUser me = userPro.user(uid: AuthMethods.uid);
      final AppUser otherLive = userPro.user(uid: user.uid);
      final bool isSupporter =
          otherLive.supporters?.contains(AuthMethods.uid) ?? false;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: <Widget>[
            Flexible(
              child: CustomElevatedButton(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(7.5),
                borderRadius: borderRadius,
                bgColor: isSupporter ? Colors.transparent : null,
                border: isSupporter ? border : null,
                textStyle: isSupporter ? textStyle : null,
                title: isSupporter ? 'Supporting' : 'Support',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 6),
            // if (isSupporter || (user.isPublicProfile ?? false))
            Flexible(
              child: CustomElevatedButton(
                borderRadius: borderRadius,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(7.5),
                border: border,
                bgColor: Colors.transparent,
                textStyle: textStyle,
                title: 'Message',
                onTap: () {
                  final String chatID =
                      UniqueIdFunctions.personalChatID(chatWith: user.uid);
                  Navigator.of(context).push(
                    MaterialPageRoute<PersonalChatScreen>(
                      builder: (BuildContext context) => PersonalChatScreen(
                          chatWith: user,
                          chat: Chat(
                            chatID: chatID,
                            persons: <String>[AuthMethods.uid, user.uid],
                          )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
