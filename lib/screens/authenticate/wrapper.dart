import 'package:flutter/material.dart';
import '../../screens/authenticate/widgets/logo_loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../frame.dart';
import 'authenticate.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

var logger = Logger();

class _WrapperState extends State<Wrapper> {
  Future<String> isUserSignedIn() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String uid = pref.getString('id') ?? '';
      return uid;
    } catch (error) {
      // Обработка ошибок, например, запись в лог или показ уведомления пользователю
      logger.e('Ошибка при чтении SharedPreferences: $error');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: isUserSignedIn(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.data == '' || snap.data == null || snap.data == 'null') {
              return const Authenticate();
            } else {
              return Frame(id: int.parse(snap.data.toString()));
            }
          } else {
            return logoLoadingWidget();
          }
        }
        // return const Authenticate();
        );
  }
}
