import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../feature/auth/login_page.dart';
import '../feature/auth/role_selected_page.dart';
import '../feature/customer/home_page.dart';
import '../feature/customer/handyman_list_page.dart';
import '../feature/customer/handyman_detail_page.dart';
import '../feature/customer/booking_form_page.dart';
import '../feature/shared/my_requests_page.dart';
import '../feature/handyman/profile_setup.dart';
import '../feature/handyman/requests_list_page.dart';
import '../feature/handyman/request_detail_page.dart';

class AppRouter {
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (_, __) => const NoTransitionPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/role',
        name: 'role_select',
        pageBuilder: (_, __) => const NoTransitionPage(child: RoleSelectPage()),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (_, __) =>
            const NoTransitionPage(child: CustomerHomePage()),
      ),
      GoRoute(
        path: '/handymen',
        name: 'handyman_list',
        pageBuilder: (_, __) =>
            const NoTransitionPage(child: HandymanListPage()),
      ),
      GoRoute(
        path: '/handyman/:id',
        name: 'handyman_detail',
        builder: (_, state) =>
            HandymanDetailPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/book/:id',
        name: 'booking_form',
        builder: (_, state) =>
            BookingFormPage(handymanId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/requests',
        name: 'my_requests',
        pageBuilder: (_, __) => const NoTransitionPage(child: MyRequestsPage()),
      ),
      GoRoute(
        path: '/handyman/profile',
        name: 'handyman_profile_setup',
        pageBuilder: (_, __) =>
            const NoTransitionPage(child: ProfileSetupPage()),
      ),
      GoRoute(
        path: '/handyman/inbox',
        name: 'handyman_requests',
        pageBuilder: (_, __) =>
            const NoTransitionPage(child: HandymanRequestsListPage()),
      ),
      GoRoute(
        path: '/handyman/request/:id',
        name: 'handyman_request_detail',
        builder: (_, state) =>
            RequestDetailPage(requestId: state.pathParameters['id']!),
      ),
    ],
  );
}
