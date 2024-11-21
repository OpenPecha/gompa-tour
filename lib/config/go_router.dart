import 'package:go_router/go_router.dart';
import 'package:gompa_tour/ui/screen/deties_list_screen.dart';

import '../ui/screen/deties_detail_screen.dart';
import '../ui/screen/skeleton_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const SkeletonScreen();
        }),
    GoRoute(
      path: DetiesListScreen.routeName,
      builder: (context, state) {
        return const DetiesListScreen();
      },
    ),
    GoRoute(
      path: DeityDetailScreen.routeName,
      builder: (context, state) {
        return const DeityDetailScreen();
      },
    )
  ],
);
