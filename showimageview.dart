import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class showimage extends StatefulWidget {
  const showimage({Key? key}) : super(key: key);

  @override
  State<showimage> createState() => _showimageState();
}

class _showimageState extends State<showimage> {
  @override
  Widget build(BuildContext context) {
    final Url = ModalRoute.of(context)?.settings.arguments as String;
    return Container(
      child: Image(
        image: NetworkImage(Url),
      ),
    );
  }
}
