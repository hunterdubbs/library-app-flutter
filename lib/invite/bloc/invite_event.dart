part of 'invite_bloc.dart';

abstract class InviteEvent extends Equatable {
  const InviteEvent();

  @override
  List<Object> get props => [];
}

class LoadInvites extends InviteEvent {
  const LoadInvites();
}

class AcceptInvite extends InviteEvent {
  const AcceptInvite(this.invite);

  final Invite invite;

  @override
  List<Object> get props => [invite];
}

class RejectInvite extends InviteEvent {
  const RejectInvite(this.invite);

  final Invite invite;

  @override
  List<Object> get props => [invite];
}
