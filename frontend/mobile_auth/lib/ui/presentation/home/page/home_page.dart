import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_auth/ui/presentation/home/cubit/home_cubit.dart';
import 'package:mobile_auth/ui/presentation/login/page/login_page.dart';
import 'package:mobile_auth/ui/presentation/results/page/results_page.dart';
import 'package:mobile_auth/ui/util/extensions.dart';
import 'package:mobile_auth/ui/widgets/general_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cubit = HomeCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: context.width,
          height: context.height,
          child: BlocProvider<HomeCubit>(
            create: (context) {
              return cubit;
            },
            child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeInProgressState) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        key: cubit.alertKey,
                        content: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(child: CircularProgressIndicator())),
                      );
                    },
                  );
                }
        
                if(state is HomeSignOutState){
                  if (cubit.alertKey.currentContext != null &&
                      (ModalRoute.of(cubit.alertKey.currentContext!)?.isCurrent ??
                          false)) {
                    context.pop;
                  }
        
                  context.pushReplacement(const LoginPage());
                }
        
                if (state is HomeSuccessState) {
                  if (cubit.alertKey.currentContext != null &&
                      (ModalRoute.of(cubit.alertKey.currentContext!)?.isCurrent ??
                          false)) {
                    context.pop;
                  }
        
                  Fluttertoast.showToast(
                      msg: 'Upload Succeed!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
        
                if (state is HomeFailureState) {
                  if (cubit.alertKey.currentContext != null &&
                      (ModalRoute.of(cubit.alertKey.currentContext!)?.isCurrent ??
                          false)) {
                    context.pop;
                  }
        
                  Fluttertoast.showToast(
                      msg: '',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: (){
                          cubit.signOut();
                        },
                        child: const Icon(Icons.exit_to_app_outlined, color: Colors.black, size: 60,),
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * .15),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  const Text(
                    'Click the button below to get the thumbnails',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: context.height * .1),
                  GeneralButton(
                    width: context.width / 1.1,
                    onClick: () {
                      context.push(const ResultsPage());
                    },
                    color: Colors.grey,
                    child: const Text(
                      'Get Results',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: context.height * .02),
                  GeneralButton(
                    width: context.width / 1.1,
                    onClick: () {
                      FilePicker.platform.pickFiles(type: FileType.image).then((file){
                        if(file != null){
                          cubit.uploadImage(File(file.files.first.xFile.path));
                        }
                      });
                    },
                    color: Colors.red,
                    child: const Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
