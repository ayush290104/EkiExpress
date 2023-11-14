import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/body/social_log_in_body.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class SocialLoginWidget extends StatefulWidget {
  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
  );

  GoogleSignInAccount _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      // if (isAuthorized) {
      //   unawaited(_handleGetContact(account!));
      // }
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Get.find<SplashController>().configModel.socialLogin.isNotEmpty &&
            (Get.find<SplashController>().configModel.socialLogin[0].status ||
                Get.find<SplashController>().configModel.socialLogin[1].status)
        ? Column(children: [
            Center(child: Text('social_login'.tr, style: robotoMedium)),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Get.find<SplashController>().configModel.socialLogin[0].status
                  ? InkWell(
                      onTap: () async {
                        try {
                          if (!kIsWeb) {
                            debugPrint("tapped");
                            final GoogleSignInAccount usercredential =
                                await GoogleSignIn().signIn();
                            debugPrint("tapped3");
                            final GoogleSignInAuthentication _auth =
                                await usercredential.authentication;
                            debugPrint("tapped2");
                            final AuthCredential credential =
                                GoogleAuthProvider.credential(
                              accessToken: _auth.accessToken,
                              idToken: _auth.idToken,
                            );
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);
                            if (usercredential != null) {
                              //debugPrint("tapped ${_googleSignIn.currentUser.displayName}");
                              Get.find<AuthController>()
                                  .loginWithSocialMedia(SocialLogInBody(
                                email: usercredential.email,
                                token: _auth.idToken,
                                uniqueId: usercredential.id,
                                medium: 'google',
                              ));
                            }
                          } else {
                            GoogleAuthProvider googleauthprovider =
                                GoogleAuthProvider();
                            final UserCredential usercredential =
                                await FirebaseAuth.instance
                                    .signInWithPopup(googleauthprovider);
                            GoogleSignInAccount _googleAccount =
                                await _googleSignIn.signInSilently(
                                    reAuthenticate: true);
                            debugPrint(
                                "account is ${usercredential.additionalUserInfo.username}, ");
                            GoogleSignInAuthentication _auth =
                                await _googleAccount.authentication;

                            if (usercredential != null) {
                              debugPrint(
                                  "tapped ${_googleSignIn.currentUser.displayName}");
                              Get.find<AuthController>()
                                  .loginWithSocialMedia(SocialLogInBody(
                                email: _googleAccount.email,
                                token: _auth.idToken,
                                uniqueId: _googleAccount.id,
                                medium: 'google',
                              ));
                            }
                          }
                        } catch (error) {
                          debugPrint("error is $error");
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Image.asset(Images.google),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                  width: Get.find<SplashController>()
                          .configModel
                          .socialLogin[0]
                          .status
                      ? Dimensions.PADDING_SIZE_SMALL
                      : 0),
              // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Get.find<SplashController>().configModel.socialLogin[1].status
                  ? InkWell(
                      onTap: () async {
                        LoginResult _result =
                            await FacebookAuth.instance.login();
                        if (_result.status == LoginStatus.success) {
                          Map _userData =
                              await FacebookAuth.instance.getUserData();
                          if (_userData != null) {
                            Get.find<AuthController>()
                                .loginWithSocialMedia(SocialLogInBody(
                              email: _userData['email'],
                              token: _result.accessToken.token,
                              uniqueId: _result.accessToken.userId,
                              medium: 'facebook',
                            ));
                          }
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Image.asset(Images.facebook),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Get.find<SplashController>().configModel.appleLogin.isNotEmpty &&
                      Get.find<SplashController>()
                          .configModel
                          .appleLogin[0]
                          .status &&
                      !GetPlatform.isAndroid &&
                      !GetPlatform.isWeb
                  ? InkWell(
                      onTap: () async {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                          webAuthenticationOptions: WebAuthenticationOptions(
                            clientId: Get.find<SplashController>()
                                .configModel
                                .appleLogin[0]
                                .clientId,
                            redirectUri: Uri.parse(
                                'https://6ammart-web.6amtech.com/apple'),
                          ),
                        );
                        Get.find<AuthController>()
                            .loginWithSocialMedia(SocialLogInBody(
                          email: credential.email,
                          token: credential.authorizationCode,
                          uniqueId: credential.authorizationCode,
                          medium: 'apple',
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Image.asset(Images.apple_logo),
                      ),
                    )
                  : SizedBox(),
            ]),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          ])
        : SizedBox();
  }
}
