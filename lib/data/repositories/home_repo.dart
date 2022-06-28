import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/home_provider.dart';

class HomeRepository {
  List<Claim> _claims = [];
  final HomeProvider _provider = HomeProvider();

  Future<List<Claim>> getClaims() async {
    _claims = await _provider.getClaims();
    return _claims;
  }

  List<Claim> getClaimList() {
    return _claims;
  }
}
