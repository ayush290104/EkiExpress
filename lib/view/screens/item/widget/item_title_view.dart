import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';import 'dart:io';

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


import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';import 'package:sixam_mart/data/model/response/store_model.dart';import 'package:share_plus/share_plus.dart' as share_plus;

import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';import 'package:http/http.dart' as http;

import 'package:sixam_mart/view/base/rating_bar.dart';

class ItemTitleView extends StatelessWidget {
  final Item item;
  final bool inStorePage;
  final bool isCampaign;
  final bool inStock;
  ItemTitleView(
      {@required this.item,
      this.inStorePage = false,
      this.isCampaign = false,
      @required this.inStock});
  Future<String> downloadFile(String url, String name) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final appDir = await getExternalStorageDirectory();
        final filename =
            '$name.png'; // Set the desired file name and extension.
        final file = File('${appDir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
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
    var imagesString = "Images: \n";
    images.forEach((element) {
      imagesString = imagesString + element + "\n";
    });
    imagesString = imagesString + "\n Details: \n" + text;
    share_plus.Share.share(imagesString);
  }

  @override
  Widget build(BuildContext context) {
    print('-----------$inStock');
    print(inStock ? 'out_of_stock'.tr : 'in_stock'.tr);
    final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _startingPrice;
    double _endingPrice;
    if (item.variations.length != 0) {
      List<double> _priceList = [];
      item.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = item.price;
    }

    return ResponsiveHelper.isDesktop(context)
        ? GetBuilder<ItemController>(builder: (itemController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: robotoMedium.copyWith(fontSize: 30),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                InkWell(
                  onTap: () {
                    if (inStorePage) {
                      Get.back();
                    } else {
                      Get.offNamed(
                          RouteHelper.getStoreRoute(item.storeId, 'item'));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Text(
                      item.storeName,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                RatingBar(
                    rating: item.avgRating,
                    ratingCount: item.ratingCount,
                    size: 21),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Row(children: [
                  Text(
                    '${PriceConverter.convertPrice(_startingPrice, discount: item.discount, discountType: item.discountType)}'
                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: item.discount, discountType: item.discountType)}' : ''}',
                    style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(width: 10),
                  item.discount > 0
                      ? Flexible(
                          child: Text(
                            '${PriceConverter.convertPrice(_startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                            textDirection: TextDirection.ltr,
                            style: robotoRegular.copyWith(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: inStock ? Colors.red : Colors.green,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                    child: Text(inStock ? 'out_of_stock'.tr : 'in_stock'.tr,
                        style: robotoRegular.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall,
                        )),
                  ),
                ]),
              ],
            );
          })
        : Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: GetBuilder<ItemController>(
              builder: (itemController) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(
                          item.name ?? '',
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        GetBuilder<WishListController>(
                            builder: (wishController) {
                          return Column(
                            children: [
                              // Text(
                              //   wishController.localWishes.contains(item.id) ? (item.wishlistCount+1).toString() : wishController.localRemovedWishes
                              //       .contains(item.id) ? (item.wishlistCount-1).toString() : item.wishlistCount.toString(),
                              //   style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                              // ),
                              // SizedBox(width: 5),

                              InkWell(
                                onTap: () {
                                  if (_isLoggedIn) {
                                    if (wishController.wishItemIdList
                                        .contains(item.id)) {
                                      wishController.removeFromWishList(
                                          item.id, false);
                                    } else {
                                      wishController.addToWishList(
                                          item, null, false);
                                    }
                                  } else
                                    showCustomSnackBar(
                                        'you_are_not_logged_in'.tr);
                                },
                                child: Icon(
                                  wishController.wishItemIdList
                                          .contains(item.id)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 25,
                                  color: wishController.wishItemIdList
                                          .contains(item.id)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                ),
                              ),

                              InkWell(
                                onTap:
                                    () async {
                                  String
                                  messageToSend =
                                      "Look what I found out.\n\n${item.name}\n\n${item.description}\n\n  https://ekiexpress.com/item-details?id=${item.id}&page=item";

                                  if(GetPlatform.isAndroid || GetPlatform.isIOS)               {
                                    await downloadFile("${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" +item.image,
                                        item.name)
                                        .then((value) {
                                      if (value !=
                                          null)
                                        Share.shareFiles([
                                          value
                                        ], text: messageToSend);
                                      else
                                        Share.share(messageToSend);
                                    });
                                  }
                                  else if(GetPlatform.isWeb){
                                    shareImage(
                                        ["${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/" + item.image],
                                        messageToSend);
                                  }
                                },
                                child: Icon(
                                    Icons
                                        .share),
                              ),
                            ],
                          );
                        }),
                      ]),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          if (inStorePage) {
                            Get.back();
                          } else {
                            Get.offNamed(RouteHelper.getStoreRoute(
                                item.storeId, 'item'));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: Text(
                            item.storeName,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                    '${PriceConverter.convertPrice(_startingPrice, discount: item.discount, discountType: item.discountType)}'
                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: item.discount, discountType: item.discountType)}' : ''}',
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeLarge),
                                    textDirection: TextDirection.ltr,
                                  ),
                                  SizedBox(height: 5),
                                  item.discount > 0
                                      ? Text(
                                          '${PriceConverter.convertPrice(_startingPrice)}'
                                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                                          textDirection: TextDirection.ltr,
                                          style: robotoRegular.copyWith(
                                              color:
                                                  Theme.of(context).hintColor,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        )
                                      : SizedBox(),
                                  SizedBox(height: item.discount > 0 ? 5 : 0),
                                  !isCampaign
                                      ? Row(children: [
                                          Text(
                                              item.avgRating.toStringAsFixed(1),
                                              style: robotoRegular.copyWith(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                              )),
                                          SizedBox(width: 5),
                                          RatingBar(
                                              rating: item.avgRating,
                                              ratingCount: item.ratingCount),
                                        ])
                                      : SizedBox(),
                                ])),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                color: inStock ? Colors.red : Colors.green,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                              ),
                              child: Text(
                                  inStock ? 'out_of_stock'.tr : 'in_stock'.tr,
                                  style: robotoRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: Dimensions.fontSizeSmall,
                                  )),
                            ),
                          ]),
                    ]);
              },
            ),
          );
  }
}
