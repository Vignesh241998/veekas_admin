import 'package:flutter/material.dart';

import '../widgets/login_form.dart';
import '../widgets/login_left_panel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: LayoutBuilder(

        builder: (context, constraints) {


          // Mobile View

          if (constraints.maxWidth < 900) {

            return const Center(

              child: SingleChildScrollView(

                padding: EdgeInsets.all(24),

                child: LoginForm(),

              ),

            );

          }



          // Web / Desktop View

          return Row(

            children: [


              Expanded(

                flex: 5,

                child: LoginLeftPanel(),

              ),



              Expanded(

                flex: 5,

                child: Center(

                  child: SingleChildScrollView(

                    padding: const EdgeInsets.all(50),

                    child: Container(

                      constraints:
                      const BoxConstraints(
                        maxWidth: 450,
                      ),


                      child:
                      const LoginForm(),

                    ),

                  ),

                ),

              ),


            ],

          );

        },

      ),

    );

  }

}