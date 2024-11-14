import 'package:chat_app/controller/auth_services.dart';
import 'package:chat_app/utils/color_constants.dart';
import 'package:chat_app/utils/image_constants.dart';
import 'package:chat_app/view/registration_screen/registration_screen.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final formkey = GlobalKey<FormState>();
    final provObj = context.watch<AuthServices>();

    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConstants.logo,
                height: 120,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextfield(
                data: "EMAIL",
                controller: email,
                isPassword: false,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextfield(
                data: "PASSWORD",
                controller: password,
                isPassword: true,
              ),
              SizedBox(
                height: 20,
              ),
              provObj.isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  ColorConstants.blueGrey)),
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              await provObj.onLogin(
                                  email: email.text,
                                  pass: password.text,
                                  context: context);
                            }
                          },
                          child: Text(
                            "SignIn",
                            style: TextStyle(
                                color: ColorConstants.black, fontSize: 20),
                          )),
                    ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: ColorConstants.grey1, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ));
                      },
                      child: Text(
                        "SignUp Now",
                        style: TextStyle(
                            color: ColorConstants.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
