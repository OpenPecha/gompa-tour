import 'package:go_router/go_router.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/screen/festival_detail_screen.dart';
import 'package:gompa_tour/ui/screen/festival_list_screen.dart';
import 'package:gompa_tour/ui/screen/organization_detail_screen.dart';
import 'package:gompa_tour/ui/screen/organization_list_screen.dart';
import 'package:gompa_tour/ui/screen/orginatzations_screen.dart';
import 'package:gompa_tour/ui/screen/pilgrimage_detail_screen.dart';
import 'package:gompa_tour/ui/screen/pilgrimage_list_screen.dart';

import '../ui/screen/deities_detail_screen.dart';
import '../ui/screen/skeleton_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SkeletonScreen();
      },
    ),
    GoRoute(
      path: DeitiesListScreen.routeName,
      builder: (context, state) {
        return const DeitiesListScreen();
      },
    ),
    GoRoute(
      path: DeityDetailScreen.routeName,
      builder: (context, state) {
        return const DeityDetailScreen();
      },
    ),
    GoRoute(
      path: OrganizationListScreen.routeName,
      builder: (context, state) {
        return OrganizationListScreen();
      },
    ),
    GoRoute(
        path: OrginatzationsScreen.routeName,
        builder: (context, state) {
          return const OrginatzationsScreen();
        }),
    GoRoute(
      path: OrganizationDetailScreen.routeName,
      builder: (context, state) {
        return const OrganizationDetailScreen();
      },
    ),
    GoRoute(
      path: FestivalListScreen.routeName,
      builder: (context, state) {
        return const FestivalListScreen();
      },
    ),
    GoRoute(
      path: FestivalDetailScreen.routeName,
      builder: (context, state) {
        return const FestivalDetailScreen();
      },
    ),
    GoRoute(
      path: PilgrimageListScreen.routeName,
      builder: (context, state) {
        return const PilgrimageListScreen();
      },
    ),
    GoRoute(
      path: PilgrimageDetailScreen.routeName,
      builder: (context, state) {
        return const PilgrimageDetailScreen();
      },
    ),
  ],
);
