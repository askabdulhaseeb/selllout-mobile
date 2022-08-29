import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_widgets/custom_network_image.dart';
import '../../models/chat/message_attachment.dart';

class MessageAttachmentScreen extends StatefulWidget {
  const MessageAttachmentScreen({required this.attachments, Key? key})
      : super(key: key);
  final List<MessageAttachment> attachments;

  @override
  State<MessageAttachmentScreen> createState() =>
      _MessageAttachmentScreenState();
}

class _MessageAttachmentScreenState extends State<MessageAttachmentScreen> {
  final CarouselController carouselController = CarouselController();
  final ScrollController listController = ScrollController();

  final GlobalKey itemKey = GlobalKey();
  int activeIndex = 0;
  Future<void> scrollToItem() async {
    final BuildContext context = itemKey.currentContext!;
    await Scrollable.ensureVisible(
      context,
      alignment: 0.5,
      duration: const Duration(microseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Center(
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: widget.attachments.length,
                options: CarouselOptions(
                  height: double.infinity,
                  aspectRatio: 1,
                  viewportFraction: 1,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    setState(() {
                      activeIndex = index;
                      listController.jumpTo(activeIndex + 0.0);
                      setState(() {});
                    });
                  },
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return CustomNetworkImage(
                    imageURL: widget.attachments[index].url,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  controller: listController,
                  itemCount: widget.attachments.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 4),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    key: ValueKey<String>(widget.attachments[index].url),
                    onTap: () {
                      activeIndex = index;
                      carouselController.animateToPage(index);
                      setState(() {});
                    },
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          height: 80,
                          child: CustomNetworkImage(
                            imageURL: widget.attachments[index].url,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 100,
                          color: activeIndex == index
                              ? Colors.transparent
                              : Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 8),
                color: Colors.black26,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 16,
                      icon: Icon(
                        Icons.adaptive.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Attachments',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
