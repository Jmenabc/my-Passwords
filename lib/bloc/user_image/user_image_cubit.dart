import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'user_image_state.dart';

class UserImageCubit extends Cubit<UserImageState> {
  UserImageCubit() : super(UserImageInitial());

  void uploadImage(Uint8List? byte, String uid) async {
    FirebaseStorage.instance.ref('profile/$uid');
  }

  void getImage(String uid) async {
    final ref =
        await FirebaseStorage.instance.ref('profile/$uid.jpg').getDownloadURL();
    emit(ImageLoadedState(ref));
  }
}
