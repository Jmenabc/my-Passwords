part of 'user_image_cubit.dart';

@immutable
abstract class UserImageState {}

class UserImageInitial extends UserImageState {}

class UploadedLoadedState extends UserImageState {}

class ImageLoadingState extends UserImageState {}

class ImageLoadedState extends UserImageState {
  final String url;

  ImageLoadedState(this.url);
}

class ErrorUploadImageState extends UserImageState {}
