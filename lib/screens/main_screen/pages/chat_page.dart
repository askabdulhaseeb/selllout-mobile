import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../database/auth_methods.dart';
import '../../../enums/chat/message_tabbar_enum.dart';
import '../../../functions/user_bottom_sheets.dart';
import '../../../models/app_user.dart';
import '../../../providers/chat/chat_page_provider.dart';
import '../../../providers/user/user_provider.dart';
import '../../../utilities/app_image.dart';
import '../../../utilities/dimensions.dart';
import '../../../utilities/styles.dart';
import '../../../widgets/chat/chat_person_search.dart';
import '../../../widgets/custom_widgets/custom_app_bar.dart';
import '../../../widgets/custom_widgets/custom_search_field.dart';
import '../../../widgets/custom_widgets/sub_app_bar.dart';
import '../../chat_screens/group_chat_page/create_group_screen.dart';
import '../../chat_screens/group_chat_page/group_chat_dashboard.dart';
import '../../chat_screens/personal_chat_page/personal_chat_dashboard.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    ChatPageProvider page = Provider.of<ChatPageProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: false),
      body: Column(
        children: <Widget>[

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SubAppBar(title: 'Messages', back: false,),
          ),


          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: _TabBar(page: page),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomSearchField(
                      controller: searchController,
                      hint: 'Search Here',
                      prefix: Icons.search,
                      iconPressed: (){}),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    if (page.currentTab == MessageTabBarEnum.chat) {
                      final List<AppUser> suppters =
                      Provider.of<UserProvider>(context, listen: false)
                          .supporters(uid: AuthMethods.uid);
                      UserBottomSheets().showNewChatPersons(
                        context: context,
                        users: suppters,
                      );
                    } else if (page.currentTab == MessageTabBarEnum.group) {
                      Navigator.of(context)
                          .pushNamed(CreateChatGroupScreen.routeName);
                    }

                  },
                  splashRadius: 16,
                  padding: const EdgeInsets.all(0),
                  icon:  SizedBox(width: 25, child: Image.asset(AppImages.chatAdd)),
                ),
              ],
            ),
          ),
          Expanded(
            child: (page.currentTab == MessageTabBarEnum.chat)
                ? const PersonalChatDashboard()
                :(page.currentTab == MessageTabBarEnum.group)?
            const GroupChatDashboard():
            const GroupChatDashboard(),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required ChatPageProvider page, Key? key})
      : _page = page,
        super(key: key);

  final ChatPageProvider _page;

  @override
  Widget build(BuildContext context) {
    double iconSize = 40;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: MessageTypeItem(title: 'Chats',icon: AppImages.message,index: 0,selectedIndex: 0,),
          ),

          const SizedBox(width: 15,),

          Expanded(
            child: MessageTypeItem(title: 'Groups',icon: AppImages.groupMessage,index: 1,selectedIndex: 0,),
          ),

          const SizedBox(width: 15,),

          Expanded(
            child: MessageTypeItem(title: 'Stories',icon: AppImages.stories,index: 2,selectedIndex: 0,),
          ),

        ],
      ),
    );
  }
}

class MessageTypeItem extends StatelessWidget {
  final String icon;
  final String title;
  final int index;
  final int selectedIndex;
  const MessageTypeItem({Key? key, required this.icon, required this.title, required this.index, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width/15;
    return  Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: index == selectedIndex ? [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2), blurRadius: 5, spreadRadius: 2)]
              : [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.03), blurRadius: 2, spreadRadius: 3)]
      ),
      child: Column(children: [
        SizedBox(width: iconSize,height: iconSize,
            child: Image.asset(icon)),
        const SizedBox(height: 10,),
        Text(title, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),)
      ],),

    );
  }
}


class TabBarIconButton extends StatelessWidget {
  const TabBarIconButton({
    required this.onTab,
    required this.icon,
    required this.title,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);
  final bool isSelected;
  final IconData icon;
  final String title;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    final Color? color = isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).iconTheme.color;
    return GestureDetector(
      onTap: onTab,
      child: Column(
        children: <Widget>[
          Icon(icon, color: color),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
