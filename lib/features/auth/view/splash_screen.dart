import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/storage/preference_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });


  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}



class _SplashScreenState
    extends State<SplashScreen> {


  @override
  void initState() {

    super.initState();

    checkLogin();

  }




  Future<void> checkLogin() async {


    await Future.delayed(
      const Duration(seconds: 2),
    );



    final isLoggedIn =
    PreferenceService.isLoggedIn();



    if(!mounted) return;



    if(isLoggedIn){


      Navigator.pushReplacementNamed(
        context,
        "/dashboard",
      );


    }else{


      Navigator.pushReplacementNamed(
        context,
        "/login",
      );


    }

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      AppColors.primary,


      body: Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [



            Container(

              height:100,

              width:100,


              decoration:
              const BoxDecoration(

                color: Colors.white,

                shape:
                BoxShape.circle,

              ),



              child:
              const Icon(

                Icons.shopping_bag_rounded,

                size:60,

                color:
                AppColors.primary,

              ),

            ),




            const SizedBox(height:30),




            Text(

              "VEEKAS ADMIN",

              style:
              AppTextStyles.heading
                  .copyWith(

                color:
                Colors.white,

              ),

            ),





            const SizedBox(height:10),




            Text(

              "Manage your e-commerce business",

              style:
              AppTextStyles.body
                  .copyWith(

                color:
                Colors.white70,

              ),

            ),





            const SizedBox(height:40),




            const CircularProgressIndicator(

              color:
              Colors.white,

            )


          ],

        ),

      ),

    );

  }

}