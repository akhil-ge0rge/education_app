import 'package:education_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
          title: 'Brand New Carriculum',
          image: MediaRes.casualReading,
          description:
              'This is the first online education platform designed by the '
              "world's top professors",
        );
  const PageContent.second()
      : this(
          title: 'Brand a fun atmosphere',
          image: MediaRes.casualLife,
          description:
              'This is the first online education platform designed by the '
              "world's top professors",
        );
  const PageContent.third()
      : this(
          title: 'Easy to join the lesson',
          image: MediaRes.casualMeditation,
          description:
              'This is the first online education platform designed by the '
              "world's top professors",
        );

  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [image, description, title];
}
