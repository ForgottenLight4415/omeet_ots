import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/home_provider.dart';

class HomeRepository {
  List<Claim> _claims = [];

  Future<List<Claim>> getClaims() async {
    _claims = await HomeProvider.getClaims();
    return _claims;
  }

  List<Claim> getClaimList() {
    return _claims;
  }
}