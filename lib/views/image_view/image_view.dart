import 'package:firebase_realtime_chat/views/image_view/image_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stacked/stacked.dart';

class ImageView extends StackedView<ImageViewModel> {
  final String url;
  final bool downloadButtonShow;
  const ImageView({Key? key, required this.url, this.downloadButtonShow = true})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ImageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(url),
          ),
          if (downloadButtonShow)
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                onPressed: () {
                  viewModel.saveImage(context, url);
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.grey.shade500,
                  child: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Positioned(
          //   top: 50,
          //   left: 20,
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: const Icon(
          //       Icons.close,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  ImageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ImageViewModel();
}
