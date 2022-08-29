import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../database/auth_methods.dart';
import '../../../functions/time_date_functions.dart';
import '../../../models/app_user.dart';
import '../../../models/chat/chat.dart';
import '../../../models/product/product.dart';
import '../../../providers/product/product_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../screens/chat_screens/personal_chat_page/product_chat_screen.dart';
import '../../custom_widgets/custom_profile_image.dart';
import '../../custom_widgets/network_video_player.dart';

class ProductChatDashboardTile extends StatelessWidget {
  const ProductChatDashboardTile({required this.chat, Key? key})
      : super(key: key);
  final Chat chat;
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ProductProvider>(builder: (
      BuildContext context,
      UserProvider userPro,
      ProductProvider prodPro,
      _,
    ) {
      final Product product = prodPro.product(chat.pid!);
      final AppUser user = userPro.user(
          uid: chat.persons[chat.persons
              .indexWhere((String element) => element != AuthMethods.uid)]);
      return ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<ProductChatScreen>(
              builder: (_) => ProductChatScreen(
                chatWith: user,
                chat: chat,
                product: product,
              ),
            ),
          );
        },
        dense: true,
        leading: Stack(
          children: <Widget>[
            product.prodURL[0].isVideo
                ? SizedBox(
                    height: 40,
                    width: 40,
                    child: NetworkVideoPlayer(
                      url: product.prodURL[0].url,
                      isMute: true,
                      isPlay: false,
                    ),
                  )
                : CustomProfileImage(imageURL: product.prodURL[0].url),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomProfileImage(
                imageURL: user.imageURL ?? '',
                radius: 28,
              ),
            ),
          ],
        ),
        title: Text(
          user.displayName ?? 'issue',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          chat.lastMessage?.text ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          TimeDateFunctions.timeInDigits(chat.timestamp),
          style: const TextStyle(fontSize: 12),
        ),
      );
    });
  }
}
