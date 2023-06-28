import 'package:domain_models/domain_models.dart';
import 'package:server_api/server_api.dart';

extension PostRMtoDomain on PostRM {
  Post toDomainModel() {
    return Post(
      id: id,
      content: content,
      imgUrl: imgUrl,
    );
  }
}
