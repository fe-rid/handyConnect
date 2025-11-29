import 'dart:math';

import '../../core/models/enums.dart';
import '../../core/models/handyman.dart';

class MockData {
  static final _rand = Random(42);

  static List<HandymanProfile> handymen = [
    HandymanProfile(
      id: 'h1',
      userId: 'u2',
      fullName: 'Alex Johnson',
      serviceType: ServiceCategory.plumber,
      description: 'Emergency fixes, pipe replacements, leak detection.',
      experienceYears: 6,
      location: 'Downtown',
      contactLinks: {
        'whatsapp': 'https://wa.me/15551234567',
        'phone': 'tel:+15551234567',
      },
      photoUrl: null,
    ),
    HandymanProfile(
      id: 'h2',
      userId: 'u3',
      fullName: 'Maria Garcia',
      serviceType: ServiceCategory.electrician,
      description: 'Wiring, outlets, breaker panels, and lighting installs.',
      experienceYears: 8,
      location: 'Uptown',
      contactLinks: {
        'telegram': 'https://t.me/example',
        'phone': 'tel:+15559876543',
      },
      photoUrl: null,
    ),
    HandymanProfile(
      id: 'h3',
      userId: 'u4',
      fullName: 'Wei Chen',
      serviceType: ServiceCategory.carpenter,
      description: 'Custom furniture, cabinets, and repairs.',
      experienceYears: 5,
      location: 'Midtown',
      contactLinks: {
        'whatsapp': 'https://wa.me/15557654321',
      },
      photoUrl: null,
    ),
  ];

  static String newId(String prefix) => '$prefix-${_rand.nextInt(1 << 32)}';
}
