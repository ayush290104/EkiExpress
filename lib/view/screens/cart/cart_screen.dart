import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:share_whatsapp/share_whatsapp.dart';

import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/coupon_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/base/web_constrained_box.dart';
import 'package:sixam_mart/view/screens/cart/widget/cart_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/response/cart_model.dart';
import '../../../data/model/response/item_model.dart';
import '../../../helper/date_converter.dart';

class CartScreen extends StatefulWidget {
  final fromNav;
  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          backButton: (ResponsiveHelper.isDesktop(context) || !widget.fromNav)),
      endDrawer: MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<CartController>(
        builder: (cartController) {
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _addOns = 0;
          cartController.cartList.forEach((cartModel) {

            List<AddOns> _addOnList = [];
            cartModel.addOnIds.forEach((addOnId) {
              for(AddOns addOns in cartModel.item.addOns) {
                if(addOns.id == addOnId.id) {
                  _addOnList.add(addOns);
                  break;
                }
              }
            });
            _addOnsList.add(_addOnList);

            _availableList.add(DateConverter.isAvailable(cartModel.item.availableTimeStarts, cartModel.item.availableTimeEnds));

            for(int index=0; index<_addOnList.length; index++) {
              _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
            }
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _addOns;

          return cartController.cartList.length > 0
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding: ResponsiveHelper.isDesktop(context)
                              ? EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_SMALL,
                                )
                              : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          child: FooterView(
                            child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product
                                    WebConstrainedBox(
                                      dataLength:
                                          cartController.cartList.length,
                                      minLength: 5,
                                      minHeight: 0.6,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            cartController.cartList.length,
                                        itemBuilder: (context, index) {
                                          return CartItemWidget(
                                              cart: cartController
                                                  .cartList[index],
                                              cartIndex: index,
                                              addOns: cartController
                                                  .addOnsList[index],
                                              isAvailable: cartController
                                                  .availableList[index]);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),

                                    // Total
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('item_price'.tr,
                                              style: robotoRegular),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  cartController.itemPrice),
                                              style: robotoRegular,
                                              textDirection: TextDirection.ltr),
                                        ]),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('discount'.tr,
                                              style: robotoRegular),
                                          Text(
                                              '(-) ${PriceConverter.convertPrice(cartController.itemDiscountPrice)}',
                                              style: robotoRegular,
                                              textDirection: TextDirection.ltr),
                                        ]),
                                    SizedBox(
                                        height: Get.find<SplashController>()
                                                .configModel
                                                .moduleConfig
                                                .module
                                                .addOn
                                            ? 10
                                            : 0),

                                    Get.find<SplashController>()
                                            .configModel
                                            .moduleConfig
                                            .module
                                            .addOn
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('addons'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                  '(+) ${PriceConverter.convertPrice(cartController.addOns)}',
                                                  style: robotoRegular,
                                                  textDirection:
                                                      TextDirection.ltr),
                                            ],
                                          )
                                        : SizedBox(),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Divider(
                                          thickness: 1,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.5)),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('subtotal'.tr,
                                            style: robotoMedium),
                                        Text(
                                            PriceConverter.convertPrice(
                                                cartController.subTotal),
                                            style: robotoMedium,
                                            textDirection: TextDirection.ltr),
                                      ],
                                    ),

                                    ResponsiveHelper.isDesktop(context)
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  buttonText: "Share Cart",
                                                  margin: EdgeInsets.all(15),
                                                  onPressed: () async {
                                                    String messageToSend =
                                                        "Hello, I am buying the following things from EkiExpress and wanted to know if you want to add anything";

                                                    cartController.cartList
                                                        .forEach((element) {
                                                      messageToSend =
                                                          messageToSend +
                                                              "\n\n*${element.item.name}* \n\n${element.item.description}\n\nPer unit price:${element.discountedPrice}\n\nQuantity:${element.quantity}";
                                                    });
                                                    messageToSend = messageToSend +
                                                        "\n\n*Subtotal:* ${cartController.subTotal}\n*Discount:* ${cartController.itemDiscountPrice}\n*Total Price*:${cartController.itemPrice}\n\nDelivery Charges will be applied on location basis.\n\nClick here to visit website https://ekiexpress.com/";

                                                    if (GetPlatform.isAndroid ||
                                                        GetPlatform.isIOS)
                                                      await getAllFiles(
                                                              cartController
                                                                  .cartList)
                                                          .then((files) async {
                                                        await Share.share(
                                                            messageToSend);
                                                        // else
                                                        //   await Share.shareFiles(files,
                                                        //       text: messageToSend);
                                                      });

                                                    if (GetPlatform.isWeb) {
                                                     _showShareDialog(context, messageToSend,'${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${cartController.cartList[0].item.image}');
                                                      //share_plus.Share.shareWithResult(messageToSend);
                                                      // await getAllFiles(cartController.cartList)
                                                      //     .then((files) async {
                                                      //
                                                      //   if(files!=null){
                                                      //     share_plus.Share.shareXFiles(files, text: messageToSend);
                                                      //   }
                                                      //
                                                      //   else{
                                                      //
                                                      //   }
                                                      //   // else
                                                      //   //   await Share.shareFiles(files,
                                                      //   //       text: messageToSend);
                                                      // });

                                                      // shareImage(
                                                      //     List.generate(
                                                      //         cartController.cartList.length,
                                                      //         (index) =>
                                                      //             "${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${cartController.cartList[index].item.image}"),
                                                      //     messageToSend);
                                                    }
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: CheckoutButton(
                                                    cartController:
                                                        cartController,
                                                    availableList:
                                                        cartController
                                                            .availableList),
                                              ),
                                            ],
                                          )
                                        : SizedBox.shrink(),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ResponsiveHelper.isDesktop(context)
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              CustomButton(
                                buttonText: "Share Cart",
                                margin: EdgeInsets.all(15),
                                onPressed: () async {
                                  String messageToSend =
                                      "Hello, I am buying the following things from EkiExpress and wanted to know if you want to add anything";

                                  cartController.cartList.forEach((element) {
                                    messageToSend = messageToSend +
                                        "\n\n*${element.item.name}* \n\n${element.item.description}\n\nPer unit price:${element.discountedPrice}\n\nQuantity:${element.quantity}";
                                  });
                                  messageToSend = messageToSend +
                                      "\n\n*Subtotal:* ${cartController.subTotal}\n*Discount:* ${cartController.itemDiscountPrice}\n*Total Price*:${cartController.itemPrice}\n\nDelivery Charges will be applied on location basis.\n\nClick here to visit website https://ekiexpress.com/";

                                  if (GetPlatform.isAndroid ||
                                      GetPlatform.isIOS)
                                    await getAllFiles(cartController.cartList)
                                        .then((files) async {
                                          if(files!=null){
                                            String s = "";
                                            cartController.cartList.forEach((element) {s += '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${element.item.image}\n'; });
                                            messageToSend = s + messageToSend;
                                            messageToSend = ""+messageToSend;
                                            share_plus.Share.shareXFiles([files[0]], text: messageToSend);
                                          }

                                      else{
                                            Share.share(messageToSend);
                                          }

                                    });

                                  if (GetPlatform.isWeb){
          _showShareDialog(context, messageToSend,'${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${cartController.cartList[0].item.image}');

          // await getAllFiles(cartController.cartList)
                                    //     .then((files) async {
                                    //
                                    //   if(files!=null){
                                    //     share_plus.Share.shareXFiles(files, text: messageToSend);
                                    //   }
                                    //
                                    //   else{
                                    //     share_plus.Share.shareWithResult(messageToSend);
                                    //   }
                                    //   // else
                                    //   //   await Share.shareFiles(files,
                                    //   //       text: messageToSend);
                                    // });

                                    // shareImage(
                                    //     List.generate(
                                    //         cartController.cartList.length,
                                    //         (index) =>
                                    //             "${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${cartController.cartList[index].item.image}"),
                                    //     messageToSend);
                                  }
                                },
                              ),
                              CheckoutButton(
                                  cartController: cartController,
                                  availableList: cartController.availableList),
                            ],
                          ),
                  ],
                )
              : NoDataScreen(isCart: true, text: '', showFooter: true);
        },
      ),
    );
  }

  Future<share_plus.XFile> downloadFile(String url, String name) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final appDir = await getExternalStorageDirectory();
        final filename =
            '$name.png'; // Set the desired file name and extension.
        final file = File('${appDir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return XFile(file.path);
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error while downloading file: $e');
      return null;
    }
  }

  Future<void> shareImage(List<String> images, String text) async {
    log("message");
    var imagesString = "Images: \n";
    images.forEach((element) {
      imagesString = imagesString + element + "\n";
    });
    imagesString = imagesString + "\n Details: \n" + text;
    launchUrl(Uri.parse("whatsapp://send?text=" + imagesString));
  }

  Future<List<XFile>> getAllFiles(List<CartModel> cartList) async {
    List<XFile> files = [];

    try {
      for (var element in cartList) {
        XFile file = await downloadFile(
            '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${element.item.image}',
            element.item.name);
        files.add(file);
      }
    } catch (e) {
      print(e);
    }

    return files;
  }
}

Future<void> _showShareDialog(BuildContext context,String Texttoshare,String ImageUrl) async {
  String selectedShareOption = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Share Via'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShareOption(context, 'Whatsapp'),
            _buildShareOption(context, 'Facebook'),
            _buildShareOption(context, 'Email'),
            _buildShareOption(context, 'Twitter'),
          ],
        ),
      );
    },
  );

  if (selectedShareOption != null) {
    await _handleShareOption(selectedShareOption,Texttoshare,ImageUrl);
  }
}
Widget _buildShareOption(BuildContext context, String option) {
  return ListTile(
    leading: option=='Facebook'?Logo(Logos.facebook_logo):option=='Email'?Logo(Logos.gmail):option=='Whatsapp'?Logo(Logos.whatsapp):Logo(Logos.twitter),
    title: Text(option),
    onTap: () {
      Navigator.of(context).pop(option);
    },
    dense: true,
  );
}
Future<void> _handleShareOption(String selectedOption,String textToShare,String imageUrl) async {
  String shareUrl = '';
  switch (selectedOption){
    case 'Whatsapp':
      final encodedText = Uri.encodeFull(textToShare);
      shareUrl = 'https://wa.me/?text=$encodedText';
      break;
    case 'Facebook':
    // Facebook sharing logic
      final facebookBaseUrl = 'https://www.facebook.com/sharer/sharer.php';
      final encodedUrl = Uri.encodeFull(imageUrl); // Replace imageUrl with the image you want to share

      // URL parameters for the Facebook sharing dialog
      final params = {
        'u': encodedUrl,
        'quote': "Look what i found out this recipe",
        'app_id': '336219982350210'
      };

      final queryString = Uri(queryParameters: params).query;
      shareUrl = '$facebookBaseUrl?$queryString';
      break;
  // Handle other cases (Email, Twitter) similarly
  // ...
    case 'Email':
      String TexttoShare = textToShare.length<700 ?textToShare:textToShare.substring(0,700);
      final emailBaseUrl = 'mailto:?';
      final encodedSubject = Uri.encodeFull('Shared from My App').replaceAll('%20',' '); // Customize subject as needed
      final encodedBody = Uri.encodeFull(textToShare).replaceAll('%20',' '); // Customize body as needed

      // URL parameters for the Email sharing
      final params = {
        'subject': 'Look What I Found Out',
        'body': TexttoShare + "Visit ",

        // Other optional parameters: cc, bcc, etc.
      };

      final queryString = Uri(queryParameters: params).query;
      shareUrl = '$emailBaseUrl$queryString';
      break;
    case 'Twitter':

      final twitterBaseUrl = 'https://twitter.com/intent/tweet';
      final encodedText = Uri.encodeFull(textToShare); // Customize as needed

      // URL parameters for the Twitter sharing
      final params = {
        'text': "Look at my cart from EkiExpress \n\n Visit \n https://ekiexpress.com\n\n",
        'via':'EkiExpress',
        'hashtags': "EkiExpress",
        'url' : imageUrl,

        // Other optional parameters: via, hashtags, etc.
      };

      final queryString = Uri(queryParameters: params).query;
      shareUrl = '$twitterBaseUrl?$queryString';
      break;

    default:
      break;
  }

  if (shareUrl.isNotEmpty) {
    debugPrint(shareUrl);
    if (await canLaunch(shareUrl)) {
      await launch(shareUrl);
    } else {
      throw 'Could not launch $shareUrl';
    }
  }
}

class CheckoutButton extends StatelessWidget {
  final CartController cartController;
  final List<bool> availableList;
  const CheckoutButton(
      {Key key, @required this.cartController, @required this.availableList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.WEB_MAX_WIDTH,
      padding: ResponsiveHelper.isDesktop(context)
          ? EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE)
          : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: CustomButton(
          buttonText: 'proceed_to_checkout'.tr,
          onPressed: () {
            /*if(Get.find<SplashController>().module == null) {
          showCustomSnackBar('choose_a_module_first'.tr);
        }else */
            if (!cartController.cartList.first.item.scheduleOrder &&
                availableList.contains(false)) {
              showCustomSnackBar('one_or_more_product_unavailable'.tr);
            } else {
              if (Get.find<SplashController>().module == null) {
                int i = 0;
                for (i = 0;
                    i < Get.find<SplashController>().moduleList.length;
                    i++) {
                  if (cartController.cartList[0].item.moduleId ==
                      Get.find<SplashController>().moduleList[i].id) {
                    break;
                  }
                }
                Get.find<SplashController>()
                    .setModule(Get.find<SplashController>().moduleList[i]);
              }
              Get.find<CouponController>().removeCouponData(false);

              Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
            }
          }),
    );
  }
}
