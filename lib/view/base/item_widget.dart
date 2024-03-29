import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/response/cart_model.dart';
import '../screens/item/widget/addtocartbutton.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final Store store;
  final bool isStore;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  ItemWidget(
      {@required this.item,
      @required this.isStore,
      @required this.store,
      @required this.index,
      @required this.length,
      this.inStore = false,
      this.isCampaign = false,
      this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    if (isStore) {
      _discount = store.discount != null ? store.discount.discount : 0;
      _discountType =
          store.discount != null ? store.discount.discountType : 'percent';
      // bool _isClosedToday = Get.find<StoreController>().isRestaurantClosed(true, store.active, store.offDay);
      // _isAvailable = DateConverter.isAvailable(store.openingTime, store.closeingTime) && store.active && !_isClosedToday;
      _isAvailable = store.open == 1 && store.active;
    } else {
      _discount = (item.storeDiscount == 0 || isCampaign)
          ? item.discount
          : item.storeDiscount;
      _discountType = (item.storeDiscount == 0 || isCampaign)
          ? item.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
          item.availableTimeStarts, item.availableTimeEnds);
    }

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
      return InkWell(
        onTap: () {
          if (isStore) {
            if (store != null) {
              if (isFeatured && Get.find<SplashController>().moduleList != null) {
                for (ModuleModel module
                in Get.find<SplashController>().moduleList) {
                  if (module.id == store.moduleId) {
                    Get.find<SplashController>().setModule(module);
                    break;
                  }
                }
              }
              Get.toNamed(
                RouteHelper.getStoreRoute(
                    store.id, isFeatured ? 'module' : 'item'),
                arguments: StoreScreen(store: store, fromModule: isFeatured),
              );
            }
          } else {
            if (isFeatured && Get.find<SplashController>().moduleList != null) {
              for (ModuleModel module
              in Get.find<SplashController>().moduleList) {
                if (module.id == item.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.find<ItemController>().navigateToItemPage(item, context,
                inStore: inStore, isCampaign: isCampaign);
          }
        },
        child: Container(
          padding: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
              : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: ResponsiveHelper.isDesktop(context)
                ? Theme.of(context).cardColor
                : null,
            boxShadow: ResponsiveHelper.isDesktop(context)
                ? [
              BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]
                : null,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: CustomImage(
                          image:
                          '${isCampaign ? _baseUrls.campaignImageUrl : isStore ? _baseUrls.storeImageUrl : _baseUrls.itemImageUrl}'
                              '/${isStore ? store != null ? store.logo : '' : item.image}',
                          height: _desktop
                              ? 120
                              : length == null
                              ? 100
                              : 65,
                          width: _desktop ? 120 : 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DiscountTag(
                        discount: _discount,
                        discountType: _discountType,
                        freeDelivery: isStore ? store.freeDelivery : false,
                      ),
                      _isAvailable
                          ? SizedBox()
                          : NotAvailableWidget(isStore: isStore),
                    ]),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isStore ? store.name : item.name,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                              maxLines: _desktop ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                                height: isStore
                                    ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                    : 0),
                            (isStore ? store.address != null : item.storeName != null)
                                ? Text(
                              isStore
                                  ? store.address ?? ''
                                  : item.storeName ?? '',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                                : SizedBox(),
                            SizedBox(
                                height: ((_desktop || isStore) &&
                                    (isStore
                                        ? store.address != null
                                        : item.storeName != null))
                                    ? 5
                                    : 0),
                            !isStore
                                ? RatingBar(
                              rating:
                              isStore ? store.avgRating : item.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isStore
                                  ? store.ratingCount
                                  : item.ratingCount,
                            )
                                : SizedBox(),
                            SizedBox(
                                height: (!isStore && _desktop)
                                    ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                    : 0),
                            isStore
                                ? RatingBar(
                              rating:
                              isStore ? store.avgRating : item.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isStore
                                  ? store.ratingCount
                                  : item.ratingCount,
                            )
                                : Row(children: [
                              Text(
                                PriceConverter.convertPrice(item.price,
                                    discount: _discount,
                                    discountType: _discountType),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                textDirection: TextDirection.ltr,
                              ),
                              SizedBox(
                                  width: _discount > 0
                                      ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                      : 0),
                              _discount > 0
                                  ? Text(
                                PriceConverter.convertPrice(item.price),
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).disabledColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                textDirection: TextDirection.ltr,
                              )
                                  : SizedBox(),
                            ]),
                          ]),
                    ),
                    Column(
                        mainAxisAlignment: isStore
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          !isStore
                              ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: _desktop
                                      ? Dimensions.PADDING_SIZE_SMALL
                                      : 0),
                              child:  AddToCart(itemController,_cartModel,item.stock,item))

                          //A
                              : SizedBox(),
                          GetBuilder<WishListController>(builder: (wishController) {
                            bool _isWished = isStore
                                ? wishController.wishStoreIdList.contains(store.id)
                                : wishController.wishItemIdList.contains(item.id);
                            return InkWell(
                              onTap: !wishController.isRemoving
                                  ? () {
                                if (Get.find<AuthController>().isLoggedIn()) {
                                  _isWished
                                      ? wishController.removeFromWishList(
                                      isStore ? store.id : item.id, isStore)
                                      : wishController.addToWishList(
                                      item, store, isStore);
                                } else {
                                  showCustomSnackBar(
                                      'you_are_not_logged_in'.tr);
                                }
                              }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                    _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                                child: Icon(
                                  _isWished ? Icons.favorite : Icons.favorite_border,
                                  size: _desktop ? 30 : 25,
                                  color: _isWished
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            );
                          }),
                        ]),
                  ]),
                )),
            _desktop || length == null
                ? SizedBox()
                : Padding(
              padding: EdgeInsets.only(left: _desktop ? 130 : 90),
              child: Divider(
                  color: index == length - 1
                      ? Colors.transparent
                      : Theme.of(context).disabledColor),
            ),
          ]),
        ),
      );
    });
      ;
  }
}
