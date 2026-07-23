import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../view/register_screen.dart';
import '../viewmodal/auth_view_model.dart';


class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}


class _LoginFormState extends ConsumerState<LoginForm> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;


  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }


  Future<void> login() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }


    await ref
        .read(authViewModelProvider.notifier)
        .login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );


    final state = ref.read(authViewModelProvider);


    if (!mounted) return;


    state.when(
      data: (data) {

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

      error: (error, stackTrace){

        AppSnackbar.error(
          context,
          error.toString()
              .replaceAll("Exception:", ""),
        );

      },

      loading: () {},

    );

  }



  @override
  Widget build(BuildContext context) {


    final authState = ref.watch(authViewModelProvider);


    return Form(

      key: _formKey,

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [


          Text(
            "Login",
            style: AppTextStyles.title,
          ),


          const SizedBox(height: 25),



          AppTextField(

            controller: emailController,

            hintText: "Enter your email",

            labelText: "Email",

            prefixIcon: Icons.email_outlined,

            keyboardType:
            TextInputType.emailAddress,

            validator:
            Validators.email,

          ),



          const SizedBox(height: 18),



          AppTextField(

            controller: passwordController,

            hintText: "Enter your password",

            labelText: "Password",

            prefixIcon:
            Icons.lock_outline,


            obscureText:
            hidePassword,


            suffixIcon: IconButton(

              icon: Icon(

                hidePassword
                    ? Icons.visibility_off
                    : Icons.visibility,

              ),


              onPressed: (){

                setState(() {

                  hidePassword =
                  !hidePassword;

                });

              },

            ),


            validator:
            Validators.password,

          ),



          const SizedBox(height: 30),



          AppButton(

            text: "Login",

            isLoading:
            authState.isLoading,


            onPressed:
            login,

          ),



          const SizedBox(height: 20),



          Row(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [


              const Text(
                "Don't have an account?",
              ),



              TextButton(

                onPressed: (){


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const RegisterScreen(),
                    ),
                  );



                },


                child: const Text(
                  "Register",
                ),

              ),

            ],

          ),


        ],

      ),

    );

  }

}