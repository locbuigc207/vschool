import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_info.g.dart';

@JsonSerializable()
class AuthInfo extends Equatable {
  final String? accessToken;
  final int? expiresIn;
  final String? refreshToken;
  final int? refreshExpiresIn;
  final String? tokenType;
  final String? sessionState;
  final String? scope;
  final bool? isEtc;

  const AuthInfo({
    this.accessToken,
    this.expiresIn,
    this.refreshToken,
    this.refreshExpiresIn,
    this.tokenType,
    this.sessionState,
    this.scope,
    this.isEtc,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) =>
      _$AuthInfoFromJson(json);

  @override
  List<Object?> get props => [accessToken, refreshToken, sessionState, scope];
}

@JsonSerializable()
class AuthMessage extends Equatable {
  final String? error;
  final String? errorDescription;

  const AuthMessage({
    this.error,
    this.errorDescription,
  });

  factory AuthMessage.fromJson(Map<String, dynamic> json) =>
      _$AuthMessageFromJson(json);

  @override
  List<Object?> get props => [error, errorDescription];
}
