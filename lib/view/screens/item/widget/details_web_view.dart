import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:sixam_mart/view/screens/item/item_details_screen.dart';
import 'package:sixam_mart/view/screens/item/widget/item_title_view.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/data/model/response/category_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';import 'package:share_plus/share_plus.dart' as share_plus;

import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/item_widget.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:sixam_mart/view/screens/store/widget/store_description_view.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailsWebView extends StatelessWidget {
  final CartModel cartModel;
  final int stock;
  final double priceWithAddOns;
  const DetailsWebView({@required this.cartModel, @required this.stock, @required this.priceWithAddOns});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<String> _imageList = [];
      _imageList.add(itemController.item.image);
      _imageList.addAll(itemController.item.images);

      String _baseUrl = itemController.item.availableDateStarts == null ? Get.find<SplashController>().
      configModel.baseUrls.itemImageUrl : Get.find<SplashController>().configModel.baseUrls.campaignImageUrl;

      return SingleChildScrollView(child: FooterView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height -560),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 20),
            Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4,child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: Get.size.height*0.5,
                          child: CustomImage(
                            fit: BoxFit.cover,
                            image: '$_baseUrl/${_imageList[itemController.productSelect]}',
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(height: 70, child: itemController.item.image != null ? ListView.builder(
                          itemCount: _imageList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                              child: InkWell(
                                onTap: () => itemController.setSelect(index,true),
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    border: Border.all(color: index == itemController.productSelect ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                        width: index == itemController.productSelect ? 2 : 1),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: CustomImage(
                                    fit: BoxFit.cover,
                                    image: '$_baseUrl/${_imageList[index]}',
                                  ),
                                ),
                              ),
                            );
                          },
                        ) : SizedBox(),)
                      ],
                    ),
                  )),
                  SizedBox(width: 40),
                  Expanded(flex: 6, child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemTitleView(item: itemController.item, inStock: Get.find<SplashController>().configModel.moduleConfig.module.stock && stock <= 0),
                        SizedBox(height: 35),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemController.item.choiceOptions.length,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(itemController.item.choiceOptions[index].title??"", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? 6.5 : (1 / 0.25),
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: itemController.item.choiceOptions[index].options.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      itemController.setCartVariationIndex(index, i, itemController.item);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      decoration: BoxDecoration(
                                        color: itemController.variationIndex[index] != i ? Theme.of(context).disabledColor : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: itemController.variationIndex[index] != i ? Border.all(color: Theme.of(context).disabledColor, width: 2) : null,
                                      ),
                                      child: Text(
                                        itemController.item.choiceOptions[index].options[i].trim(), maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: robotoRegular.copyWith(
                                          color: itemController.variationIndex[index] != i ? Colors.black : Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: index != itemController.item.choiceOptions.length-1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                            ]);
                          },
                        ),

                        SizedBox(height: 30),

                        GetBuilder<CartController>(builder: (cartController) {
                          return Row(children: [
                            QuantityButton(
                              isIncrement: false, quantity: itemController.cartIndex != -1 ? cartController.cartList[itemController.cartIndex].quantity : itemController.quantity,
                              stock: stock, isExistInCart : itemController.cartIndex != -1, cartIndex: itemController.cartIndex,
                            ),
                            SizedBox(width: 30),

                            Text(
                              itemController.cartIndex != -1 ? cartController.cartList[itemController.cartIndex].quantity.toString() : itemController.quantity.toString(),
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                            ),
                            SizedBox(width: 30),

                            QuantityButton(
                              isIncrement: true, quantity: itemController.cartIndex != -1 ? cartController.cartList[itemController.cartIndex].quantity : itemController.quantity,
                              stock: stock, cartIndex: itemController.cartIndex, isExistInCart: itemController.cartIndex != -1,
                            ),

                          ]);
                        }),
                        SizedBox(height: 30),

                        GetBuilder<CartController>(
                          builder: (cartController) {
                            return Row(children: [
                              Text('${'total_amount'.tr}:', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(PriceConverter.convertPrice(itemController.cartIndex != -1 ?
                              (cartController.cartList[itemController.cartIndex].discountedPrice * cartController.cartList[itemController.cartIndex].quantity)
                                  : priceWithAddOns ?? 0.0), textDirection: TextDirection.ltr, style: robotoBold.copyWith(
                                color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                              )),
                            ]);
                          }
                        ),
                        SizedBox(height: 30),

                        SizedBox(width: 400, child: Row(children: [
                          Expanded(flex:5, child: Container(
                            child: CustomButton(
                              buttonText: (Get.find<SplashController>().configModel.moduleConfig.module.stock && stock <= 0) ? 'out_of_stock'.tr
                                  : itemController.item.availableDateStarts != null ? 'order_now'.tr : itemController.cartIndex != -1 ? 'update_in_cart'.tr : 'add_to_cart'.tr,
                              onPressed: (!Get.find<SplashController>().configModel.moduleConfig.module.stock || stock > 0) ?  () {
                                if(itemController.item.availableDateStarts != null) {
                                  Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                                    storeId: null, fromCart: false, cartList: [cartModel],
                                  ));
                                }else if (Get.find<CartController>().existAnotherStoreItem(cartModel.item.storeId, Get.find<SplashController>().module.id)) {
                                  Get.dialog(ConfirmationDialog(
                                    icon: Images.warning,
                                    title: 'are_you_sure_to_reset'.tr,
                                    description: Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                                        ? 'if_you_continue'.tr : 'if_you_continue_without_another_store'.tr,
                                    onYesPressed: () {
                                      Get.back();
                                      Get.find<CartController>().removeAllAndAddToCart(cartModel);
                                      showCustomSnackBar('item_added_to_cart'.tr, isError: false);
                                    },
                                  ), barrierDismissible: false);
                                } else {
                                  if(itemController.cartIndex == -1) {
                                    Get.find<CartController>().addToCart(cartModel, itemController.cartIndex);
                                  }
                                  showCustomSnackBar('item_added_to_cart'.tr, isError: false);
                                }
                              } : null,
                            ),
                          )),
                          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                          Expanded(
                            flex:1,
                            child: Container(
                              padding: EdgeInsets.all(8), alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              ),
                              child: GetBuilder<WishListController>(
                                  builder: (wishController) {
                                    return InkWell(
                                      onTap: () {
                                        if(Get.find<AuthController>().isLoggedIn()){
                                          if(wishController.wishItemIdList.contains(itemController.item.id)) {
                                            wishController.removeFromWishList(itemController.item.id, false);
                                          }else {
                                            wishController.addToWishList(itemController.item, null, false);
                                          }
                                        }else showCustomSnackBar('you_are_not_logged_in'.tr);
                                      },
                                      child: Icon(
                                        wishController.wishItemIdList.contains(itemController.item.id) ? Icons.favorite : Icons.favorite_border, size: 25,
                                        color: wishController.wishItemIdList.contains(itemController.item.id) ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                          InkWell(
                            onTap:
                                () async {
                              debugPrint("this is tapped and works");
                              String
                              messageToSend =
                                  "Look what I found out.\n\n${itemController.item.name}\n\n${itemController.item.description}\n\n  https://ekiexpress.com/item-details?id=${itemController.item.id}&page=item";

                              if((GetPlatform.isAndroid || GetPlatform.isIOS)&&!GetPlatform.isWeb){
                                _showShareDialog(context,messageToSend,"$_baseUrl/${_imageList[itemController.productSelect]}",itemController.item.name);
                                // await downloadFile("${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" +itemController.item.image,
                                //     itemController.item.name)
                                //     .then((value) {
                                //   if (value !=
                                //       null)
                                //
                                //     share_plus.Share.shareXFiles([value], text: messageToSend);
                                //   else
                                //     Share.share(messageToSend);
                                // });
                              }
                              else if(GetPlatform.isWeb){
                                _showShareDialog(context,messageToSend,"$_baseUrl/${_imageList[itemController.productSelect]}",itemController.item.name);
                                // await downloadFile("${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" +itemController.item.image,
                                //     itemController.item.name)
                                //     .then((value) {
                                //   if (value !=
                                //       null)
                                //
                                //     share_plus.Share.shareXFiles([value], text: messageToSend);
                                //   else
                                //     share_plus.Share.shareWithResult(messageToSend);
                                // });
                              //  showShareDialog(context, ["${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" + itemController.item.image],
                                   // messageToSend);
                              }
                            },
                            child: Icon(
                              Icons
                                  .share,color: Colors.green,),
                          ),
                        ])),

                        (itemController.item.description != null && itemController.item.description.isNotEmpty) ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('description'.tr, style: robotoMedium),
                              ],
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(itemController.item.description, style: robotoRegular),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          ],
                        ) : SizedBox(),

                      ]),
                  )),
                ]))),
          ]),
        ),
      ));
    });
  }

  Future<XFile> downloadFile(String url, String name) async {
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
    debugPrint("this is a website");
    var imagesString = "Images: \n";
    images.forEach((element) {
      imagesString = imagesString + element + "\n";
    });
    imagesString = imagesString + "\n Details: \n" + text;
    share_plus.Share.share(imagesString);
  }
  void shareOnFacebook(List<String> images, String text) {
    var imagesString = "Images: \n";
    images.forEach((element) {
      imagesString = imagesString + element + "\n";
    });
    imagesString = imagesString + "\n Details: \n" + text;
    var content = Uri.encodeComponent(imagesString);
    var url = 'https://www.facebook.com/sharer/sharer.php?u=$content';
    html.window.open(url, 'Facebook');
  }

  void shareOnWhatsApp(List<String> images, String text) {
    var imagesString = "Images: \n";
    images.forEach((element) {
      imagesString = imagesString + element + "\n";
    });
    imagesString = imagesString + "\n Details: \n" + text;
    var content = Uri.encodeComponent(imagesString);
    var url = 'https://api.whatsapp.com/send?text=$content';
    html.window.open(url, 'WhatsApp');
  }

  void showShareDialog(BuildContext context,List<String> images, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share via'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  shareOnFacebook(images,text);
                  Navigator.of(context).pop();
                },
                child: Text('Facebook'),
              ),
              ElevatedButton(
                onPressed: () {
                  shareOnWhatsApp(images,text);
                  Navigator.of(context).pop();
                },
                child: Text('WhatsApp'),
              ),
            ],
          ),
        );
      },
    );
  }

}

Future<void> _showShareDialog(BuildContext context,String Texttoshare,String ImageUrl,String name) async {

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
    await _handleShareOption(selectedShareOption,Texttoshare,ImageUrl,name);
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
Future<void> _handleShareOption(String selectedOption,String textToShare,String imageUrl,String name) async {
  String shareUrl = '';
  switch (selectedOption){
    case 'Whatsapp':
      String Textfinal = imageUrl+"\n\n $textToShare";
      final encodedText = Uri.encodeFull(Textfinal);
      shareUrl = 'https://wa.me/?text=$encodedText';
      break;
    case 'Facebook':
    // Facebook sharing logic
      final facebookBaseUrl = 'https://www.facebook.com/sharer/sharer.php';
      final encodedUrl = Uri.encodeFull(imageUrl); // Replace imageUrl with the image you want to share

      // URL parameters for the Facebook sharing dialog
      final params = {
        'u': encodedUrl,
        'quote': "Look what I",
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

      // URL parameters for the Email sharing
      final params = {
        'subject': 'Look What I Found Out from EkiExpress',
        'body': TexttoShare+"\n\n $imageUrl\n Visit \n https://ekiexpress.com",

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
        'text': "Look at this from EkieExpress $name\n\n Visit \n https://ekiexpress.com\n\n",
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
