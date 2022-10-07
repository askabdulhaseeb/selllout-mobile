import 'package:flutter/material.dart';

import '../../database/auction_api.dart';
import '../../database/auth_methods.dart';
import '../../functions/time_date_functions.dart';
import '../../models/auction/auction.dart';
import '../../models/auction/bet.dart';
import '../../utilities/custom_validator.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_textformfield.dart';


class NewBitValue extends StatefulWidget {
  const NewBitValue({required this.auction, Key? key}) : super(key: key);
  final Auction auction;

  @override
  State<NewBitValue> createState() => _NewBitValueState();
}

class _NewBitValueState extends State<NewBitValue> {
  final TextEditingController _offer = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  void initState() {
    _offer.text = widget.auction.bets!.isEmpty
        ? widget.auction.startingPrice.toString()
        : widget.auction.bets![widget.auction.bets!.length - 1].amount
            .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  if (_offer.text == widget.auction.startingPrice.toString()) {
                    return;
                  }
                  double value = double.parse(_offer.text);
                  value -= 1;
                  _offer.text = value.toString();
                  setState(() {});
                },
                splashRadius: 20,
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
              Flexible(
                child: CustomTextFormField(
                  controller: _offer,
                  readOnly: _isLoading,
                  textAlign: TextAlign.center,
                  showSuffixIcon: false,
                  validator: (String? value) => CustomValidator.greaterThen(
                    value,
                    widget.auction.startingPrice,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  double value = double.parse(_offer.text);
                  value += 1;
                  _offer.text = value.toString();
                  setState(() {});
                },
                splashRadius: 20,
                icon: const Icon(
                  Icons.add_circle_outlined,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          CustomElevatedButton(
              title: 'Send Bit',
              onTap: () async {
                if (_key.currentState!.validate()) {
                  final Bet newBet = Bet(
                    uid: AuthMethods.uid,
                    amount: double.parse(_offer.text),
                    timestamp: TimeDateFunctions.timestamp,
                  );
                  widget.auction.bets!.add(newBet);
                  await AuctionAPI().updateBet(auction: widget.auction);
                }
              }),
        ],
      ),
    );
  }
}
