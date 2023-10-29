import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ImageUtils.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}


class DialogBox extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String content;
  final void Function() function;

  DialogBox({
    Key? key,
    required this.context,
    required this.title,
    required this.content,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(right: 16.0),
        height: 150,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75),
                bottomLeft: Radius.circular(75),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 20.0),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              child: const PNetworkImage(
                infoIcon,
                width: 60,
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$title!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10.0),
                  Flexible(
                    child: Text("Do you want to Delete $content?"),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          onPressed: function,
                          child: const Text("Yes")
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit? fit;
  final double? width, height;
  const PNetworkImage(this.image, {Key? key, this.fit, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) =>
      const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Image.asset(
        'assets/placeholder.jpg',
        fit: BoxFit.cover,
      ),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
