import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/item/widget/addtocartbutton.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/wishlist_controller.dart';
import '../../../../data/model/response/cart_model.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../base/custom_snackbar.dart';

class WebPopularItemView extends StatelessWidget {
  final bool isPopular;
  final ItemController itemController;
  WebPopularItemView({@required this.itemController, @required this.isPopular});

  List<List<bool>> get foodVariations => null;

  @override
  Widget build(BuildContext context) {
    List<Item> _itemList = isPopular ? itemController.popularItemList : itemController.reviewedItemList;

    return GetBuilder<ItemController>(builder: (itemController){
      int _stock = 0;
      CartModel _cartModel;
      double _priceWithAddons = 0;
      if(itemController.item != null && itemController.variationIndex != null){
        List<String> _variationList = [];
        for (int index = 0; index < itemController.item.choiceOptions.length; index++) {
          _variationList.add(itemController.item.choiceOptions[index].options[itemController.variationIndex[index]].replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = itemController.item.price;
        Variation _variation;
        debugPrint("Stock of all the elements here is stock and that is ${itemController.item.stock}");
        _stock = itemController.item.stock?? 0;
        for (Variation variation in itemController.item.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            _stock = variation.stock;
            break;
          }
        }

        double _discount = (itemController.item.availableDateStarts != null || itemController.item.storeDiscount == 0) ? itemController.item.discount : itemController.item.storeDiscount;
        String _discountType = (itemController.item.availableDateStarts != null || itemController.item.storeDiscount == 0) ? itemController.item.discountType : 'percent';
        double priceWithDiscount = PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity = priceWithDiscount * itemController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < itemController.item.addOns.length; index++) {
          if (itemController.addOnActiveList[index]) {
            addonsCost = addonsCost + (itemController.item.addOns[index].price * itemController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(id: itemController.item.addOns[index].id, quantity: itemController.addOnQtyList[index]));
            _addOnsList.add(itemController.item.addOns[index]);
          }
        }

        _cartModel = CartModel(
          price, priceWithDiscount, _variation != null ? [_variation] : [], [],
          (price - PriceConverter.convertWithDiscount(price, _discount, _discountType)),
          itemController.quantity, _addOnIdList, _addOnsList, itemController.item.availableDateStarts != null, _stock, itemController.item,
        );
        _priceWithAddons = priceWithQuantity + (Get.find<SplashController>().configModel.moduleConfig.module.addOn ? addonsCost : 0);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
            child: Text(isPopular ? 'popular_items_nearby'.tr : 'best_reviewed_item'.tr, style: robotoMedium.copyWith(fontSize: 24)),
          ),

          _itemList != null ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: (1/0.35),
              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            itemCount: _itemList.length > 5 ? 6 : _itemList.length,
            itemBuilder: (context, index){
              var item = _itemList[index];
              if(index == 5) {
                return InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getPopularItemRoute(isPopular)),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(
                        color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                        blurRadius: 5, spreadRadius: 1,
                      )],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+${_itemList.length-5}\n${'more'.tr}', textAlign: TextAlign.center,
                      style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  print('itemlist index clicked');
                  Get.find<ItemController>().navigateToItemPage(_itemList[index], context);
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  child: Row(children: [

                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: CustomImage(
                          image: '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}'
                              '/${_itemList[index].image}',
                          height: 90, width: 90, fit: BoxFit.cover,
                        ),
                      ),
                      DiscountTag(
                        discount: itemController.getDiscount(_itemList[index]),
                        discountType: itemController.getDiscountType(_itemList[index]),
                      ),
                      itemController.isAvailable(_itemList[index]) ? SizedBox() : NotAvailableWidget(),
                    ]),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            _itemList[index].name,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          Text(
                            _itemList[index].storeName,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),

                          RatingBar(
                            rating: _itemList[index].avgRating, size: 15,
                            ratingCount: _itemList[index].ratingCount,
                          ),

                          Row(
                            children: [
                              Text(
                                PriceConverter.convertPrice(
                                  _itemList[index].price, discount: _itemList[index].discount, discountType: _itemList[index].discountType,
                                ), textDirection: TextDirection.ltr,
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                              ),

                              SizedBox(width: _itemList[index].discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                              _itemList[index].discount > 0 ? Expanded(child: Text(
                                PriceConverter.convertPrice(itemController.getStartingPrice(_itemList[index])),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                  decoration: TextDecoration.lineThrough,
                                ), textDirection: TextDirection.ltr,
                              )) : Expanded(child: SizedBox()),
                              GetBuilder<WishListController>(builder: (wishController) {
                                bool _desktop = ResponsiveHelper.isDesktop(context);
                                bool isStore = true;
                                bool _isWished = isStore
                                    ? wishController.wishStoreIdList.contains( _itemList[index].storeId)
                                    : wishController.wishItemIdList.contains(item.id);
                                return InkWell(
                                  onTap: !wishController.isRemoving
                                      ? () {
                                    if (Get.find<AuthController>().isLoggedIn()) {
                                      _isWished
                                          ? wishController.removeFromWishList(
                                          isStore ?  _itemList[index].storeId : item.id, isStore)
                                          : wishController.addToWishList(
                                          item,null, isStore);
                                    } else {
                                      showCustomSnackBar(
                                          'you_are_not_logged_in'.tr);
                                    }
                                  }
                                      : null,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                        0),
                                    child: Icon(
                                      _isWished ? Icons.favorite : Icons.favorite_border,
                                      size: _desktop ? 3 : 2,
                                      color: _isWished
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ),
                                );
                              }),
                              AddToCart(itemController,_cartModel,item.stock,item)
                            ],
                          ),
                        ]),
                      ),
                    ),

                  ]),
                ),
              );
            },
          ) : WebCampaignShimmer(enabled: _itemList == null),
        ],
      );
    });
  }
}

class WebCampaignShimmer extends StatelessWidget {
  final bool enabled;
  WebCampaignShimmer({@required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: (1/0.35),
        crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      itemCount: 6,
      itemBuilder: (context, index){
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: enabled,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 90, width: 90,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.grey[300]),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 15, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                    SizedBox(height: 5),

                    Container(height: 10, width: 30, color: Colors.grey[300]),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

