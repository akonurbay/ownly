class RoutePaths {
  RoutePaths._();

  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const home = '/';
  static const timeMachine = '/time-machine';
  static const analytics = '/analytics';
  static const settings = '/settings';
  static const addPlace = '/add-place';
  static const placeDetail = '/place/:id';

  static String placeDetailFor(String id) => '/place/$id';
}
