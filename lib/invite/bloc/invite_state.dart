part of 'invite_bloc.dart';

enum InviteStatus{ initial, loading, loaded, error, modifying, modified, errorModifying }

class InviteState extends Equatable {
  const InviteState({
    this.status = InviteStatus.initial,
    this.invites = const <Invite>[],
    this.errorMsg = ''
  });

  final InviteStatus status;
  final List<Invite> invites;
  final String errorMsg;

  InviteState copyWith({
    InviteStatus? status,
    List<Invite>? invites,
    String? errorMsg
  }) {
    return InviteState(
      status: status ?? this.status,
      invites: invites ?? this.invites,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }

  @override
  List<Object> get props => [status, invites, errorMsg];
}