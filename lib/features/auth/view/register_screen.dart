import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';

import '../viewmodal/auth_view_model.dart';


class RegisterScreen extends ConsumerStatefulWidget {

  const RegisterScreen({
    super.key,
  });


  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();

}



class _RegisterScreenState
    extends ConsumerState<RegisterScreen> {


  final _formKey = GlobalKey<FormState>();


  final firstNameController =
  TextEditingController();

  final lastNameController =
  TextEditingController();

  final mobileController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();



  bool hidePassword = true;

  bool hideConfirmPassword = true;



  @override
  void dispose() {

    firstNameController.dispose();

    lastNameController.dispose();

    mobileController.dispose();

    emailController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();


    super.dispose();
  }




  Future<void> register() async {


    if(!_formKey.currentState!.validate()) {
      return;
    }



    await ref
        .read(authViewModelProvider.notifier)
        .register(

      firstName:
      firstNameController.text.trim(),

      lastName:
      lastNameController.text.trim(),

      mobile:
      mobileController.text.trim(),

      email:
      emailController.text.trim(),

      password:
      passwordController.text.trim(),

    );



    final state =
    ref.read(authViewModelProvider);



    if(!mounted) return;



    state.when(

      data: (data){


        if(data != null){


          AppSnackbar.success(
            context,
            data.message,
          );



          Navigator.pushReplacementNamed(
            context,
            "/dashboard",
          );


        }


      },


      error: (error, stack){


        AppSnackbar.error(
          context,
          error.toString()
              .replaceAll(
            "Exception:",
            "",
          ),
        );


      },


      loading: (){},


    );

  }





  @override
  Widget build(BuildContext context) {


    final authState =
    ref.watch(authViewModelProvider);



    return

      Scaffold(

      body: Center(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(30),



          child: Container(

            constraints:
            const BoxConstraints(
              maxWidth: 500,
            ),



            child: Form(

              key: _formKey,

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  Text(

                    "Create Account",

                    style:
                    AppTextStyles.heading,

                  ),



                  const SizedBox(height:30),




                  AppTextField(

                    controller:
                    firstNameController,

                    hintText:
                    "First Name",

                    prefixIcon:
                    Icons.person_outline,

                    validator: (value){

                      return Validators.required(
                        value,
                        "First Name",
                      );

                    },

                  ),



                  const SizedBox(height:15),




                  AppTextField(

                    controller:
                    lastNameController,

                    hintText:
                    "Last Name",

                    prefixIcon:
                    Icons.person_outline,

                    validator: (value){

                      return Validators.required(
                        value,
                        "Last Name",
                      );

                    },

                  ),




                  const SizedBox(height:15),




                  AppTextField(

                    controller:
                    mobileController,

                    hintText:
                    "Mobile Number",

                    prefixIcon:
                    Icons.phone_outlined,

                    keyboardType:
                    TextInputType.phone,

                    validator:
                    Validators.mobile,

                  ),





                  const SizedBox(height:15),




                  AppTextField(

                    controller:
                    emailController,

                    hintText:
                    "Email",

                    prefixIcon:
                    Icons.email_outlined,

                    keyboardType:
                    TextInputType.emailAddress,

                    validator:
                    Validators.email,

                  ),




                  const SizedBox(height:15),





                  AppTextField(

                    controller:
                    passwordController,

                    hintText:
                    "Password",

                    prefixIcon:
                    Icons.lock_outline,

                    obscureText:
                    hidePassword,


                    suffixIcon:
                    IconButton(

                      icon: Icon(

                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,

                      ),


                      onPressed: (){

                        setState((){

                          hidePassword =
                          !hidePassword;

                        });

                      },

                    ),


                    validator:
                    Validators.password,

                  ),





                  const SizedBox(height:15),





                  AppTextField(

                    controller:
                    confirmPasswordController,

                    hintText:
                    "Confirm Password",


                    prefixIcon:
                    Icons.lock_outline,


                    obscureText:
                    hideConfirmPassword,



                    suffixIcon:
                    IconButton(

                      icon: Icon(

                        hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,

                      ),



                      onPressed: (){

                        setState((){

                          hideConfirmPassword =
                          !hideConfirmPassword;

                        });

                      },

                    ),




                    validator: (value){

                      return Validators.confirmPassword(
                        passwordController.text,
                        value,
                      );

                    },


                  ),




                  const SizedBox(height:30),





                  AppButton(

                    text:
                    "Register",


                    isLoading:
                    authState.isLoading,


                    onPressed:
                    register,

                  ),





                  const SizedBox(height:20),





                  Center(

                    child: TextButton(

                      onPressed: (){

                        Navigator.pop(context);

                      },


                      child:
                      const Text(
                        "Already have account? Login",
                      ),

                    ),

                  )

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}