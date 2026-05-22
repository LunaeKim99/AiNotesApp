import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/features/notes/presentation/cubit/sidebar_cubit.dart';

void main() {
  late SidebarCubit cubit;

  setUp(() {
    cubit = SidebarCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is SidebarVisible (isVisible = true)', () {
    expect(cubit.state, isA<SidebarVisible>());
    expect(cubit.state.isVisible, true);
  });

  test('toggle() emits SidebarHidden when current is visible', () {
    cubit.toggle();
    expect(cubit.state, isA<SidebarHidden>());
    expect(cubit.state.isVisible, false);
  });

  test('toggle() twice returns to SidebarVisible', () {
    cubit.toggle();
    cubit.toggle();
    expect(cubit.state, isA<SidebarVisible>());
    expect(cubit.state.isVisible, true);
  });

  test('show() emits SidebarVisible', () {
    cubit.toggle();
    cubit.show();
    expect(cubit.state, isA<SidebarVisible>());
    expect(cubit.state.isVisible, true);
  });

  test('hide() emits SidebarHidden', () {
    cubit.hide();
    expect(cubit.state, isA<SidebarHidden>());
    expect(cubit.state.isVisible, false);
  });
}
