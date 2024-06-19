import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_auth/ui/presentation/home/page/home_page.dart';
import 'package:mobile_auth/ui/presentation/login/page/login_page.dart';
import 'package:mobile_auth/ui/util/extensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
     if(GetStorage().hasData('logged')){
       context.pushReplacement(const HomePage());
     }else{
       context.pushReplacement(const LoginPage());
     }
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
