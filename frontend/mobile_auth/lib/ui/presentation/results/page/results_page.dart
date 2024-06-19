import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_auth/ui/presentation/results/cubit/results_cubit.dart';
import 'package:mobile_auth/ui/util/extensions.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final cubit = ResultsCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Results'),
      ),
      body: SafeArea(
          child: BlocProvider<ResultsCubit>(
        create: (context) {
          cubit.getThumbnails();
          return cubit;
        },
        child: BlocConsumer<ResultsCubit, ResultsState>(
          listener: (context, state) {
            if (state is ResultsDownloadMessageState) {
              Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: state.isError ? Colors.red : Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          builder: (context, state) {
            if (state is ResultsInProgressState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ResultsFailureState) {
              return SizedBox(
                width: context.width,
                height: context.height,
                child: const Center(
                  child: Text('No Thumbnails'),
                ),
              );
            }
            return SizedBox(
              width: context.width,
              height: context.height,
              child: ListView.builder(
                itemCount: cubit.thumbnails.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: Image.network(
                                cubit.thumbnails[index].thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Id: ${cubit.thumbnails[index].thumbnailId}'),
                                SizedBox(width: context.width * .4),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        FilePicker.platform
                                            .pickFiles(type: FileType.image)
                                            .then((file) {
                                          if (file != null) {
                                            cubit.updateImage(
                                              File(file.files.single.path!),
                                              cubit.thumbnails[index]
                                                  .thumbnailId,
                                            );
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.upload_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cubit.downloadThumbnail(cubit
                                            .thumbnails[index].thumbnailUrl);
                                      },
                                      icon: const Icon(
                                          Icons.download_for_offline_outlined),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (index + 1 == cubit.thumbnails.length)
                        SizedBox(
                          width: context.width / 1.05,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (cubit.start >= 10)
                                TextButton(
                                  onPressed: () {
                                    cubit.end -= 10;
                                    cubit.start -= 10;
                                    cubit.getThumbnails();
                                  },
                                  child: const Text('Back'),
                                ),
                              if (cubit.thumbnails.length >= 10)
                                TextButton(
                                  onPressed: () {
                                    cubit.start = cubit.end + 1;
                                    cubit.end += 10;
                                    cubit.getThumbnails();
                                  },
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      )),
    );
  }
}
