import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/auth_methods.dart';
import '../models/app_user.dart';
import '../models/product/product.dart';
import '../models/reports/report_product.dart';
import '../models/reports/report_user.dart';
import '../providers/product/product_provider.dart';
import '../providers/user/user_provider.dart';
import '../widgets/custom_widgets/custom_elevated_button.dart';
import '../widgets/custom_widgets/custom_toast.dart';
import 'time_date_functions.dart';

class ReportBottomSheets {
  otherUserProfileMoreButton(BuildContext context, AppUser user) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _Handle(),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Report User',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 0.2),
            ListTile(
              onTap: () =>
                  _reportConfirmSheet(context, user, 'report', 'Report'),
              leading: const Icon(Icons.report),
              title: const Text('Report'),
            ),
            ListTile(
              onTap: () => _reportConfirmSheet(context, user, 'block', 'Block'),
              leading: const Icon(Icons.block),
              title: Text(
                (Provider.of<UserProvider>(context)
                        .user(uid: AuthMethods.uid)
                        .blockTo!
                        .contains(user.uid))
                    ? 'Unblock'
                    : 'Block',
              ),
            ),
            // ListTile(
            //   onTap: () => _reportConfirmSheet(
            //       context, user, 'report-block', 'Report & Block'),
            //   leading: const Icon(Icons.person_off_outlined),
            //   title: const Text('Report & Block'),
            // ),
          ],
        );
      },
    );
  }

  productReport(BuildContext context, Product product) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const _Handle(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Report',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('''It's a spam'''),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'spam',
                    issue: '''It's a spam''',
                    product: product,
                  );
                },
              ),
              ListTile(
                title: const Text('Sale of illegal'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'illegal-sale',
                    issue: 'Sale of illegal',
                    product: product,
                  );
                },
              ),
              ListTile(
                title: const Text('Scam'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'scam',
                    issue: 'Scam',
                    product: product,
                  );
                },
              ),
              ListTile(
                title: const Text('Hate Speech'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'hate-speech',
                    issue: 'Hate Speech',
                    product: product,
                  );
                },
              ),
              ListTile(
                title: const Text('Voilence or dangerous'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'voilence',
                    issue: 'Voilence or dangerous',
                    product: product,
                  );
                },
              ),
              ListTile(
                title: const Text('Bullying or Harrasment'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'bullying',
                    issue: 'Bullying or Harrasment',
                    product: product,
                  );
                },
              ),

              ListTile(
                title: const Text('Intellectual Property Voilation'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'intellectual-Property',
                    issue: 'Intellectual Property Voilation',
                    product: product,
                  );
                },
              ),
              ListTile(
                title: const Text('Self Injury or Sucide'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'Self-injury',
                    issue: 'Self Injury or Sucide',
                    product: product,
                  );
                },
              ),

              ListTile(
                title: const Text('False Information'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  _showreportcompletedbottom(
                    context,
                    id: 'false-information',
                    issue: 'False Information',
                    product: product,
                  );
                },
              ),
              // ListTile(
              //   title: const Text('Something Else'),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     Navigator.pop(context);
              //     showotherreasonbottom(context);
              //   },
              // ),
            ]),
          );
        });
  }
}

_showreportcompletedbottom(
  BuildContext context, {
  required String id,
  required String issue,
  required Product product,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const _Handle(),
          const SizedBox(height: 20),
          const Center(
            child: Icon(
              Icons.check_box_outlined,
              color: Colors.red,
              size: 50,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'The post has reported',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color),
              children: <TextSpan>[
                const TextSpan(text: 'You have reported this post with reason'),
                TextSpan(
                  text: ' "$issue" ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(text: 'and doesnt follow'),
                TextSpan(
                  text: ' Sellout comunity guideline',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', Team Sellout will look into your report and take action in 24 hours',
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            child: const Text('Cancel this report'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CustomElevatedButton(
            title: 'Done',
            onTap: () async {
              if (product.reports!.indexWhere((ReportProduct element) =>
                      element.reportBy == AuthMethods.uid) >=
                  0) {
                Navigator.of(context).pop();
                CustomToast.errorToast(
                    message: 'You already reported that post');
                return;
              }
              if (product.uid == AuthMethods.uid) {
                Navigator.of(context).pop();
                CustomToast.errorToast(
                    message: 'You can not report on your post');
                return;
              }
              product.reports!.add(ReportProduct(
                  reportBy: AuthMethods.uid,
                  category: id,
                  comment: issue,
                  timestamp: TimeDateFunctions.timestamp));
              Navigator.of(context).pop();
              await Provider.of<ProductProvider>(context, listen: false)
                  .report(product);
            },
          ),
        ]),
      );
    },
  );
}

_reportConfirmSheet(
  BuildContext context,
  AppUser user,
  String id,
  String comment,
) {
  Navigator.of(context).pop();
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _Handle(),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color),
              children: <TextSpan>[
                const TextSpan(text: 'Sre you sure to '),
                TextSpan(
                  text: ' "$comment" ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                TextSpan(text: user.displayName),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            child: const Text('Cancel this report'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomElevatedButton(
              title: 'Done',
              onTap: () async {
                ReportUser repo = ReportUser(
                  reportBy: AuthMethods.uid,
                  category: id,
                  comment: comment,
                  timestamp: TimeDateFunctions.timestamp,
                );
                Navigator.of(context).pop();
                if (id == 'block') {
                  await Provider.of<UserProvider>(context, listen: false)
                      .block(user);
                } else if (id == 'report') {
                  await Provider.of<UserProvider>(context, listen: false)
                      .report(user, repo);
                } else {
                  await Provider.of<UserProvider>(context, listen: false)
                      .block(user);
                  // await Provider.of<UserProvider>(context, listen: false)
                  //     .report(user, repo);
                }
              },
            ),
          ),
        ],
      );
    },
  );
}

class _Handle extends StatelessWidget {
  const _Handle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 100,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
      ),
    );
  }
}
