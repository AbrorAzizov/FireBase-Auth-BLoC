import 'package:bloc_5/bloc/auth_bloc/app_bloc.dart';
import 'package:bloc_5/bloc/auth_bloc/app_event.dart';
import 'package:bloc_5/bloc/auth_bloc/app_state.dart';
import 'package:bloc_5/dialog/delete_account_dialog.dart';
import 'package:bloc_5/dialog/logout_dialog.dart';
import 'package:bloc_5/pages/storage_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    final images = context.watch<AppBloc>().state.images?? [];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final decision = await showDeleteAccountDialog(context);
                if (!mounted) return;
                if (decision) {
                  context.read<AppBloc>().add(AppEventLogout());
                }
              },

              icon: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.blueAccent,
              )),
          IconButton(
              onPressed: () async {
                final decision = await showLogoutAccountDialog(context);
                if (decision) {
                  context.read<AppBloc>().add(AppEventDeleteAccount());
                }
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () async {
                final image = await picker.pickImage(
                    source: ImageSource.gallery);
                if (image == null) {
                  return;
                }
                context.read<AppBloc>().add(
                    AppEventUploadImage(pathToImage: image.path));
              },
              icon: Icon(
                Icons.upload_outlined,
                color: Colors.green,
              )),
        ],
      ),
      body: GridView.count(crossAxisCount: 2,
        padding: EdgeInsets.all(10),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,children:
          images.map((e) => StorageImage(images: e,)).toList()
        ,),
    );
  }
}
