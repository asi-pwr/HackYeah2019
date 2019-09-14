import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'owner.jser.dart';

@GenSerializer()
class OwnerSerializer extends Serializer<Owner> with _$OwnerSerializer {
}

class Owner {
  @Alias("profile_image")
  String profileImageUrl;
  @Alias("display_name")
  String displayName;
}
