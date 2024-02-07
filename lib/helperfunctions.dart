String leadingcaptial (String someString) {
  String newstring;
  newstring = someString.substring(0,1).toUpperCase();
  newstring = newstring + someString.substring(1,someString.length).toLowerCase();

  return newstring;
}