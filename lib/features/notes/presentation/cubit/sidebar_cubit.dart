import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SidebarState extends Equatable {
  final bool isVisible;
  const SidebarState(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

class SidebarVisible extends SidebarState {
  const SidebarVisible() : super(true);
}

class SidebarHidden extends SidebarState {
  const SidebarHidden() : super(false);
}

class SidebarCubit extends Cubit<SidebarState> {
  SidebarCubit() : super(const SidebarVisible());

  void toggle() {
    if (state is SidebarVisible) {
      emit(SidebarHidden());
    } else {
      emit(SidebarVisible());
    }
  }

  void show() => emit(const SidebarVisible());
  void hide() => emit(SidebarHidden());
}
