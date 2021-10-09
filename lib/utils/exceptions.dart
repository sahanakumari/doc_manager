class LoginException with Exception {
  final dynamic clause;
  final bool forbidden;

  LoginException([this.clause = "Login required!", this.forbidden = false]);

  String get errorMessage {
    try {
      return clause["errors"]
          .map((e) => "* ${e["message"]}")
          .toList()
          .join("\n");
    } catch (e) {
      return clause;
    }
  }

  @override
  String toString() {
    return this.clause ?? "$this";
  }
}
