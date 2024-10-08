extension M on Duration {
  String toStringTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return inHours == 0
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
