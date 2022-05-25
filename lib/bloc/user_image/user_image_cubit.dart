import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'user_image_state.dart';

class UserImageCubit extends Cubit<UserImageState> {
  UserImageCubit() : super(UserImageInitial());

  void uploadData(Uint8List fileBytes, String uid) async {
    await FirebaseStorage.instance.ref('profile/$uid.jpg').putData(fileBytes);
  }

  void getUserImage(String uid) async {
    final ref =
    await FirebaseStorage.instance.ref('profile/$uid.jpg').getDownloadURL();
    emit(ImageLoadedState(ref));
  }
}
