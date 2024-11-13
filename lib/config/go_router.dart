import 'package:go_router/go_router.dart';

import '../ui/screen/skeleton_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const SkeletonScreen();
        }),
  ],
);
