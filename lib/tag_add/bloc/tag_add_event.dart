part of 'tag_add_bloc.dart';

abstract class TagAddEvent extends Equatable {
  const TagAddEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends TagAddEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class Submitted extends TagAddEvent {
  const Submitted();
}
