import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../database/auction_api.dart';
import '../../../database/auth_methods.dart';
import '../../../enums/product/prod_privacy_type.dart';
import '../../../functions/picker_functions.dart';
import '../../../functions/time_date_functions.dart';
import '../../../functions/unique_id_functions.dart';
import '../../../models/auction/auction.dart';
import '../../../models/auction/bet.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/auction/auction_provider.dart';
import '../../../utilities/custom_services.dart';
import '../../../utilities/custom_validator.dart';
import '../../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../../widgets/custom_widgets/custom_file_image_box.dart';
import '../../../widgets/custom_widgets/custom_textformfield.dart';
import '../../../widgets/custom_widgets/custom_toast.dart';
import '../../../widgets/custom_widgets/show_loading.dart';
import '../../../widgets/custom_widgets/title_text.dart';
import '../../../widgets/product/radio_widgets/prod_privacy_widget.dart';
import 'broadcast_page.dart';

class GoLivePage extends StatefulWidget {
  const GoLivePage({Key? key}) : super(key: key);
  static const String routeName = '/go-live-page';
  @override
  State<GoLivePage> createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _decription = TextEditingController();
  final TextEditingController _price = TextEditingController();
  ProdPrivacyTypeEnum _privacy = ProdPrivacyTypeEnum.public;
  File? _file;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Go Live',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => CustomService.dismissKeyboard(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomFileImageBox(
                    file: _file,
                    onTap: () async {
                      _file = await PickerFunctions().image();
                      if (_file == null) return;
                      setState(() {});
                    },
                    title: 'Thumbnail',
                  ),
                  const CustomTitleText(title: 'Bid Name'),
                  CustomTextFormField(
                    controller: _name,
                    border: InputBorder.none,
                    validator: (String? value) =>
                        CustomValidator.lessThen3(value),
                    maxLength: 30,
                    readOnly: _isLoading,
                  ),
                  const CustomTitleText(title: 'Item Description'),
                  CustomTextFormField(
                    controller: _decription,
                    maxLines: 4,
                    readOnly: _isLoading,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (String? value) =>
                        CustomValidator.lessThen2(value),
                  ),
                  const CustomTitleText(title: 'Starting Price'),
                  CustomTextFormField(
                    controller: _price,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    readOnly: _isLoading,
                    validator: (String? value) =>
                        CustomValidator.isEmpty(value),
                  ),
                  const CustomTitleText(title: 'Privacy'),
                  ProdPrivacyWidget(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    privacy: _privacy,
                    onChanged: (ProdPrivacyTypeEnum? newPrivacy) {
                      _privacy = newPrivacy ?? ProdPrivacyTypeEnum.public;
                    },
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const ShowLoading()
                      : CustomElevatedButton(
                          title: 'Go Live',
                          onTap: () => onGoLiveTap(),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onGoLiveTap() async {
    if (_file == null) {
      CustomToast.errorToast(
        message: 'Image is required',
      );
      return;
    }
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final String id = UniqueIdFunctions.postID;
      final int time = TimeDateFunctions.timestamp;
      String? url = '';
      url = await AuctionAPI().uploadImage(id: id, file: _file!);
      final Auction auction = Auction(
        auctionID: id,
        author: AuthMethods.uid,
        coAuthors: <String>[AuthMethods.uid],
        name: _name.text,
        thumbnail: url ?? '',
        decription: _decription.text,
        startingPrice: double.parse(_price.text),
        bets: <Bet>[],
        isActive: true,
        timestamp: time,
        privacy: _privacy,
      );
      final bool started = await AuctionAPI().startAuction(auction);
      setState(() {
        _isLoading = false;
      });
      if (started) {
        CustomToast.successSnackBar(
          context: context,
          text: 'Auction started successfully',
        );
        if (!mounted) return;
        Provider.of<AuctionProvider>(context, listen: false).refresh();
        Provider.of<AppProvider>(context, listen: false).onTabTapped(0);
        await <Permission>[Permission.camera, Permission.microphone].request();
        debugPrint('Joing channel: $id');
        Navigator.of(context).push(
          MaterialPageRoute<BroadcastPage>(
            builder: (_) => BroadcastPage(auction: auction),
          ),
        );
      }
    }
  }
}
