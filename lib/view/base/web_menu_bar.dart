import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/search_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/base/text_hover.dart';
import 'package:sixam_mart/view/screens/search/widget/search_field.dart';

class WebMenuBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<WebMenuBar> createState() => _WebMenuBarState();

  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, 70);
}

class _WebMenuBarState extends State<WebMenuBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  // String _selectedType = 'Business with Eki';
  AnimationController animationController;
  bool _menuShown = false;
  LocationController locationController;

  OverlayEntry _overlayEntry;
  GlobalKey _shapedWidgetKey = GlobalKey();
  GlobalKey _scrollWidgetKey = GlobalKey();
  OverlayEntry _scrolloverlayEntry;
  SearchController _globalsearchController;

  void _createOverlay() {
    RenderBox renderBox = _shapedWidgetKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx, // Adjust this offset as needed
        top: offset.dy + 30.0, // Adjust this offset as needed
        child:
        _ShapedWidget(), // Replace YourReplacementWidget with your custom widget
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
  }

  void _scrollCreateOverlay() {
    RenderBox renderBox = _scrollWidgetKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);

    _scrolloverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx, // Adjust this offset as needed
        top: offset.dy + 30.0, // Adjust this offset as needed
        child:
        searchData1()
         // Replace YourReplacementWidget with your custom widget
      ),
    );

    Overlay.of(context).insert(_scrolloverlayEntry);
  }

  @override
  void dispose() {
    // Remove the overlay entry when the state is disposed

    _overlayEntry?.remove();
    _scrolloverlayEntry?.remove();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Create the overlay entry after the first frame is displayed
      if( _shapedWidgetKey.currentContext!=null){
        _createOverlay();
      }

      // _scrollCreateOverlay();
    });
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Animation opacityAnimation =
    //     Tween(begin: 0.0, end: 1.0).animate(animationController);
    // animationController.forward();

    return Container(
      width: double.infinity,
      // color: Theme.of(context).cardColor,
      height: 70,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Center(
          child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: Row(children: [
                InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getInitialRoute()),
                  child: Image.asset(Images.logo, width: 100),
                ),

                // Get.find<LocationController>().getUserAddress() != null ?

                Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper.getPickMapRoute(
                          RouteHelper.accessLocation,
                          false,
                        ));
                      },
                      // Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: GetBuilder<LocationController>(
                            builder: (locationController) {
                              locationController = locationController;
                              return Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        locationController.getUserAddress() == null
                                            ? Icons.location_on
                                            : locationController
                                            .getUserAddress()
                                            .addressType ==
                                            'home'
                                            ? Icons.home_filled
                                            : locationController
                                            .getUserAddress()
                                            .addressType ==
                                            'office'
                                            ? Icons.work
                                            : Icons.location_on,
                                        size: 20,
                                        color:
                                        Theme.of(context).textTheme.bodyLarge.color,
                                      ),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Flexible(
                                        child: Text(
                                          locationController.getUserAddress() == null
                                              ? "Set Location"
                                              : locationController
                                              .getUserAddress()
                                              .address,
                                          style: robotoRegular.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                .color,
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down,
                                          color: Theme.of(context).primaryColor),
                                    ],
                                  ),
                                  if (locationController.getUserAddress() == null)
                                    Positioned(
                                      key: _shapedWidgetKey,
                                      // child: _ShapedWidget(),
                                      child: SizedBox.shrink(),
                                    ),
                                ],
                              );
                            }),
                      ),
                    )),
                // : Expanded(child: SizedBox()),
                // SizedBox(width: 20),

                TextButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        Images.restaurant_join,
                        color: Colors.green,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(Get.find<SplashController>()
                          .configModel
                          .moduleConfig
                          .module
                          .showRestaurantText
                          ? 'join_as_a_restaurant'.tr
                          : 'join_as_a_store'.tr),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        Images.delivery_man_join,
                        color: Colors.green,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Join as a Dispatch Person'.tr),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 140,
                  child: GetBuilder<SearchController>(
                    builder: (searchController) {
                      _globalsearchController = searchController;

                      final oldCursorPos = _searchController.selection;
                      _searchController.value = TextEditingValue(
                        text: searchController.searchHomeText, // Replace 'new text' with the updated text
                        selection: TextSelection.collapsed(
                          offset: oldCursorPos.baseOffset <= searchController.searchHomeText.length
                              ? oldCursorPos.baseOffset
                              : searchController.searchHomeText.length,
                        ),
                      );
                     // _searchController.text = searchController.searchHomeText;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GetBuilder<SearchController>(
                            builder: (searchController) {
                              final oldCursorPos = _searchController.selection;
                              _searchController.value = TextEditingValue(
                                text: searchController.searchHomeText, // Replace 'new text' with the updated text
                                selection: TextSelection.collapsed(
                                  offset: oldCursorPos.baseOffset <= searchController.searchHomeText.length
                                      ? oldCursorPos.baseOffset
                                      : searchController.searchHomeText.length,
                                ),
                              );
                              // _searchController.text =
                              //     searchController.searchHomeText;
                              return SearchField(
                                controller: _searchController,
                                hint: Get.find<SplashController>()
                                    .configModel
                                    .moduleConfig
                                    .module
                                    .showRestaurantText
                                    ? 'search_food_or_restaurant'.tr
                                    : 'search_item_or_store'.tr,
                                suffixIcon:
                                searchController.searchHomeText.isNotEmpty
                                    ? Icons.highlight_remove
                                    : Icons.search,
                                filledColor:
                                Theme.of(context).colorScheme.background,
                                iconPressed: () {
                                  if (searchController
                                      .searchHomeText.isNotEmpty) {
                                     _searchController.text = '';
                                     searchController.clearSearchHomeText();
                                     if(_scrollWidgetKey.currentContext!=null){
                                       _scrollCreateOverlay();
                                     }
                                  } else {
                                    // searchData();
                                    if (_searchController.text.trim().isEmpty) {
                                      showCustomSnackBar(
                                          Get.find<SplashController>()
                                              .configModel
                                              .moduleConfig
                                              .module
                                              .showRestaurantText
                                              ? 'search_food_or_restaurant'.tr
                                              : 'search_item_or_store'.tr);
                                    } else {
                                      Get.toNamed(RouteHelper.getSearchRoute(
                                          queryText:
                                          _searchController.text.trim()));
                                    }
                                  }
                                },
                                onChanged: (text) async {


                                await  Get.find<SearchController>().searchData(text, true);
                                debugPrint("value of list came is here ${searchController.searchItemList.length}");
                                if(_scrollWidgetKey.currentContext!=null){
                                  _scrollCreateOverlay();
                                }
                                },
                                onSubmit: (text) {
                                  if (_searchController.text.trim().isEmpty) {
                                    showCustomSnackBar(
                                        Get.find<SplashController>()
                                            .configModel
                                            .moduleConfig
                                            .module
                                            .showRestaurantText
                                            ? 'search_food_or_restaurant'.tr
                                            : 'search_item_or_store'.tr);
                                  } else {
                                    Get.toNamed(RouteHelper.getSearchRoute(
                                        queryText:
                                        _searchController.text.trim()));
                                  }
                                },
                              );
                            },
                          ),
                          Lenge(searchController)
                          // if (searchController.searchItemList != null &&
                          //     searchController.searchItemList.isNotEmpty)
                          // Positioned(
                          //   top: 50,
                          //   key: _scrollWidgetKey,
                          //   child: SizedBox.shrink(),
                          // )
                          // else
                          //   Container(),
                        ],
                      );
                    },
                  ),
                ),

                // AutocompleteSearchField(
                //   controller:
                //       _searchController, // Provide your TextEditingController
                //   onSubmitted: (text) {
                //     // Implement search functionality based on the entered text
                //     // e.g., searchData(text);
                //   },
                // ),

                SizedBox(width: 20),

                MenuIconButton(
                    icon: Icons.notifications,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getNotificationRoute())),
                SizedBox(width: 20),
                MenuIconButton(
                    icon: Icons.favorite,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getMainRoute('favourite'))),
                SizedBox(width: 20),
                MenuIconButton(
                    icon: Icons.shopping_cart,
                    isCart: true,
                    onTap: () => Get.toNamed(RouteHelper.getCartRoute())),
                // SizedBox(width: 20),
                // GetBuilder<LocalizationController>(
                //     builder: (localizationController) {
                //   int _index = 0;
                //   List<DropdownMenuItem<int>> _languageList = [];
                //   for (int index = 0;
                //       index < AppConstants.languages.length;
                //       index++) {
                //     _languageList.add(DropdownMenuItem(
                //       child: TextHover(builder: (hovered) {
                //         return Row(children: [
                //           Image.asset(AppConstants.languages[index].imageUrl,
                //               height: 20, width: 20),
                //           SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                //           Text(AppConstants.languages[index].languageName,
                //               style: robotoRegular.copyWith(
                //                   color: hovered
                //                       ? Theme.of(context).primaryColor
                //                       : null)),
                //         ]);
                //       }),
                //       value: index,
                //     ));
                //     if (AppConstants.languages[index].languageCode ==
                //         localizationController.locale.languageCode) {
                //       _index = index;
                //     }
                //   }
                //   return DropdownButton<int>(
                //     value: _index,
                //     items: _languageList,
                //     dropdownColor: Theme.of(context).cardColor,
                //     icon: Icon(Icons.keyboard_arrow_down),
                //     elevation: 0,
                //     iconSize: 30,
                //     underline: SizedBox(),
                //     onChanged: (int index) {
                //       localizationController.setLanguage(Locale(
                //           AppConstants.languages[index].languageCode,
                //           AppConstants.languages[index].countryCode));
                //     },
                //   );
                // }),
                SizedBox(width: 20),
                MenuIconButton(
                    icon: Icons.menu,
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    }),
                SizedBox(width: 20),
                GetBuilder<AuthController>(builder: (authController) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(authController.isLoggedIn()
                          ? RouteHelper.getProfileRoute()
                          : RouteHelper.getSignInRoute(RouteHelper.main));
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(children: [
                        Icon(
                            authController.isLoggedIn()
                                ? Icons.person_pin_rounded
                                : Icons.lock,
                            size: 20,
                            color: Colors.white),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                            authController.isLoggedIn()
                                ? 'profile'.tr
                                : 'sign_in'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Colors.white)),
                      ]),
                    ),
                  );
                }),
              ]))),
    );
  }
Widget Lenge (SearchController searchController){


  if (searchController.searchItemList != null &&
      searchController.searchItemList.isNotEmpty) {
    debugPrint("searchController.searchItemList.length ${_scrollWidgetKey.currentContext.toString()}");


    return Positioned(
      top: 30,
      key: _scrollWidgetKey,
      child: SizedBox.shrink(),
    );
  } else {
    return Container();
  }
}
  Widget searchData1() {

    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);

    if(_globalsearchController == null|| _searchController.text .isEmpty) {
      return SizedBox();
    }
   debugPrint("Length of string is ${_globalsearchController.searchItemList.length}");
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Container(
          width: 400,
        height: _globalsearchController.searchItemList.length==0?0:Get.height,
        //  height: (_globalsearchController.searchItemList.length * 140).toDouble(),
          child: ListView.builder(
            itemCount: _globalsearchController.searchItemList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (_globalsearchController
                      .searchHomeText.isNotEmpty) {
                    _searchController.text = '';

                    _globalsearchController.clearSearchHomeText();
                  }
                  if(_scrollWidgetKey.currentContext!=null){
                    _scrollCreateOverlay();
                  }
                  if (Get.find<SplashController>().moduleList != null) {
                    for (ModuleModel module
                    in Get.find<SplashController>().moduleList) {
                      if (module.id ==
                          _globalsearchController.searchItemList[index].moduleId) {
                        Get.find<SplashController>().setModule(module);
                        break;
                      }
                    }
                  }
                  Get.find<ItemController>().navigateToItemPage(
                      _globalsearchController.searchItemList[index], context,
                      inStore: false, isCampaign: false);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                            _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Row(
                          children: [
                            Stack(children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                child: CustomImage(
                                  image:
                                  '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}'
                                      '/${_globalsearchController.searchItemList[index].image}',
                                  height: 120,
                                  width: _desktop ? 120 : 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              DiscountTag(
                                discount:
                                _globalsearchController.searchItemList[index].discount,
                                discountType: _globalsearchController
                                    .searchItemList[index].discountType,
                                freeDelivery: false,
                              ),
                            ]),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _globalsearchController.searchItemList[index].name,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                    maxLines: _desktop ? 2 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _globalsearchController
                                        .searchItemList[index].storeName,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RatingBar(
                                    rating: _globalsearchController
                                        .searchItemList[index].avgRating,
                                    size: _desktop ? 15 : 12,
                                    ratingCount: _globalsearchController
                                        .searchItemList[index].ratingCount,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        PriceConverter.convertPrice(
                                            _globalsearchController
                                                .searchItemList[index].price,
                                            discount: _globalsearchController
                                                .searchItemList[index].discount,
                                            discountType: _globalsearchController
                                                .searchItemList[index]
                                                .discountType),
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                        textDirection: TextDirection.ltr,
                                      ),
                                      SizedBox(
                                          width: _globalsearchController
                                              .searchItemList[index]
                                              .discount >
                                              0
                                              ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                              : 0),
                                      _globalsearchController
                                          .searchItemList[index].discount >
                                          0
                                          ? Text(
                                        PriceConverter.convertPrice(
                                            _globalsearchController
                                                .searchItemList[index].price),
                                        style: robotoMedium.copyWith(
                                          fontSize:
                                          Dimensions.fontSizeExtraSmall,
                                          color:
                                          Theme.of(context).disabledColor,
                                          decoration:
                                          TextDecoration.lineThrough,
                                        ),
                                        textDirection: TextDirection.ltr,
                                      )
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: _desktop
                                            ? Dimensions.PADDING_SIZE_SMALL
                                            : 0),
                                    child:
                                    Icon(Icons.add, size: _desktop ? 30 : 25),
                                  ),
                                  GetBuilder<WishListController>(
                                      builder: (wishController) {
                                        bool _isWished = wishController.wishItemIdList
                                            .contains(_globalsearchController
                                            .searchItemList[index].id);
                                        return InkWell(
                                          onTap: !wishController.isRemoving
                                              ? () {
                                            // if (Get.find<
                                            //         AuthController>()
                                            //     .isLoggedIn()) {
                                            //   _isWished
                                            //       ? wishController.removeFromWishList(
                                            //           searchController.searchItemList[index]
                                            //                   .id,
                                            //           false)
                                            //       : wishController
                                            //           .addToWishList(
                                            //               searchController.searchItemList[index],
                                            //               store,
                                            //               false);
                                            // } else {
                                            //   showCustomSnackBar(
                                            //       'you_are_not_logged_in'
                                            //           .tr);
                                            // }
                                          }
                                              : null,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: _desktop
                                                    ? Dimensions.PADDING_SIZE_SMALL
                                                    : 0),
                                            child: Icon(
                                              _isWished
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: _desktop ? 30 : 25,
                                              color: _isWished
                                                  ? Theme.of(context).primaryColor
                                                  : Theme.of(context).disabledColor,
                                            ),
                                          ),
                                        );
                                      }),
                                ]),
                          ],
                        ),
                      ),
                      // _desktop || length == null
                      //     ? SizedBox()
                      //     : Padding(
                      //         padding: EdgeInsets.only(
                      //             left: _desktop ? 130 : 90),
                      //         child: Divider(
                      //             color: index == length - 1
                      //                 ? Colors.transparent
                      //                 : Theme.of(context)
                      //                     .disabledColor),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void searchData() {
    if (_searchController.text.trim().isEmpty) {
      showCustomSnackBar(Get.find<SplashController>()
          .configModel
          .moduleConfig
          .module
          .showRestaurantText
          ? 'search_food_or_restaurant'.tr
          : 'search_item_or_store'.tr);
    } else {
      Get.toNamed(
          RouteHelper.getSearchRoute(queryText: _searchController.text.trim()));
    }
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  MenuButton({@required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return InkWell(
        onTap: onTap,
        child: Text(title,
            style: robotoRegular.copyWith(
                color: hovered ? Theme.of(context).primaryColor : null)),
      );
    });
  }
}

class MenuIconButton extends StatelessWidget {
  final IconData icon;
  final bool isCart;
  final Function onTap;
  const MenuIconButton(
      {@required this.icon, this.isCart = false, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return IconButton(
        onPressed: onTap,
        icon: GetBuilder<CartController>(builder: (cartController) {
          return Stack(clipBehavior: Clip.none, children: [
            Icon(
              icon,
              color: hovered
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyLarge.color,
            ),
            (isCart && cartController.cartList.length > 0)
                ? Positioned(
              top: -5,
              right: -5,
              child: Container(
                height: 15,
                width: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: Text(
                  cartController.cartList.length.toString(),
                  style: robotoRegular.copyWith(
                      fontSize: 12, color: Theme.of(context).cardColor),
                ),
              ),
            )
                : SizedBox()
          ]);
        }),
      );
    });
  }
}

class _ShapedWidget extends StatelessWidget {
  _ShapedWidget();
  final double padding = 4.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          color: Color.fromRGBO(16, 25, 54, 1),
          shape: _ShapedWidgetBorder(
            borderRadius: BorderRadius.all(Radius.circular(padding)),
            padding: padding,
          ),
          elevation: 4.0,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(16, 25, 54, 1),
            ),
            padding: EdgeInsets.all(padding).copyWith(bottom: padding * 2),
            child: Container(
              width: 200,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Set your delivery location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Text(
                        'This helps us deliver your order from the nearest store.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RouteHelper.getPickMapRoute(
                          RouteHelper.accessLocation,
                          false,
                        ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'set_location'.tr.toUpperCase(),
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class _ShapedWidgetBorder extends RoundedRectangleBorder {
  _ShapedWidgetBorder({
    @required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + 8.0, rect.top) // Start from the top left
      ..lineTo(rect.left + 20.0, rect.top - 16.0) // Move up diagonally
      ..lineTo(rect.left + 32.0, rect.top) // Move to the left
      ..addRRect(borderRadius.resolve(textDirection).toRRect(Rect.fromLTWH(
          rect.left + padding,
          rect.top,
          rect.width - padding,
          rect.height - padding))); // Draw the remaining border
  }
}

class AutocompleteSearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  AutocompleteSearchField({
    @required this.controller,
    @required this.onSubmitted,
  });

  @override
  State<AutocompleteSearchField> createState() =>
      _AutocompleteSearchFieldState();
}

class _AutocompleteSearchFieldState extends State<AutocompleteSearchField> {
  OverlayEntry _overlayEntry;
  GlobalKey _shapedWidgetKey = GlobalKey();

  void _createOverlay() {
    RenderBox renderBox = _shapedWidgetKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx, // Adjust this offset as needed
        top: offset.dy + 30.0, // Adjust this offset as needed
        child:
        _ShapedWidget(), // Replace YourReplacementWidget with your custom widget
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
  }

  @override
  void dispose() {
    // Remove the overlay entry when the state is disposed
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Create the overlay entry after the first frame is displayed
      _createOverlay();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);

    return SizedBox(
      width: 140,
      child: GetBuilder<SearchController>(
        builder: (searchController) {
          widget.controller.text = searchController.searchHomeText;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GetBuilder<SearchController>(
                builder: (searchController) {
                  widget.controller.text = searchController.searchHomeText;
                  return SearchField(
                    controller: widget.controller,
                    hint: Get.find<SplashController>()
                        .configModel
                        .moduleConfig
                        .module
                        .showRestaurantText
                        ? 'search_food_or_restaurant'.tr
                        : 'search_item_or_store'.tr,
                    suffixIcon: searchController.searchHomeText.isNotEmpty
                        ? Icons.highlight_remove
                        : Icons.search,
                    filledColor: Theme.of(context).colorScheme.background,
                    iconPressed: () {
                      if (searchController.searchHomeText.isNotEmpty) {
                        widget.controller.text = '';
                        searchController.clearSearchHomeText();
                      } else {
                        // searchData();
                        if (widget.controller.text.trim().isEmpty) {
                          showCustomSnackBar(Get.find<SplashController>()
                              .configModel
                              .moduleConfig
                              .module
                              .showRestaurantText
                              ? 'search_food_or_restaurant'.tr
                              : 'search_item_or_store'.tr);
                        } else {
                          Get.toNamed(RouteHelper.getSearchRoute(
                              queryText: widget.controller.text.trim()));
                        }
                      }
                    },
                    onChanged: (text) {

                      Get.find<SearchController>().searchData(text, true);
                    },
                    onSubmit: (text) {
                      if (widget.controller.text.trim().isEmpty) {
                        showCustomSnackBar(Get.find<SplashController>()
                            .configModel
                            .moduleConfig
                            .module
                            .showRestaurantText
                            ? 'search_food_or_restaurant'.tr
                            : 'search_item_or_store'.tr);
                      } else {
                        Get.toNamed(RouteHelper.getSearchRoute(
                            queryText: widget.controller.text.trim()));
                      }
                    },
                  );
                },
              ),
              if (searchController.searchItemList != null &&
                  searchController.searchItemList.isNotEmpty)
                Positioned(
                  top: 50,
                  key: _shapedWidgetKey,
                  child: SizedBox.shrink(),
                )
              else
                Container(),
            ],
          );
        },
      ),
    );
  }
}
