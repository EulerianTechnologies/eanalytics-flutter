int getSecondsSinceEpoch() {
  var ms = (DateTime.now()).millisecondsSinceEpoch;
  return (ms / 1000).round();
}
