import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/data/repositories/home_repo.dart';

part 'get_claims_state.dart';

class GetClaimsCubit extends Cubit<GetClaimsState> {
  final HomeRepository _homeRepository = HomeRepository();
  GetClaimsCubit() : super(GetClaimsInitial());

  Future<void> getClaims() async {
    emit(GetClaimsLoading());
    try {
      emit(GetClaimsSuccess(await _homeRepository.getClaims()));
    } on SocketException {
      emit(GetClaimsFailed(1000, "Failed to connect the server."));
    } on ServerException catch (a) {
      emit(GetClaimsFailed(a.code, a.cause));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }

  Future<void> searchClaims(String? searchQuery) async {
    List<Claim> _claims = await _homeRepository.getClaims();
    if (searchQuery == null || searchQuery.isEmpty) {
      emit(GetClaimsSuccess(_claims));
      return;
    }
    try {
      List<Claim> _result = [];
      for (var claim in _claims) {
        if (claim.claimNumber.toString() == searchQuery.trim()) {
          _result.add(claim);
        }
      }
      emit(GetClaimsSuccess(_result));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }
}
