class CustomMethods {
  static String firstName(String name) {
    if (name.isEmpty) return '';

    int index = name.indexOf(' ');

    if (index == -1) {
      return name;
    } else {
      return name.substring(0, index);
    }
  }
}
