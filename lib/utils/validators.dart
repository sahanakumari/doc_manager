class Validators {
  static final RegExp _ipv4Maybe =
      RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');
  static final RegExp _ipv6 =
      RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');

  static bool isURL(String? str,
      {List<String?> protocols = const ['http', 'https', 'ftp'],
      bool requireTld = true,
      bool requireProtocol = false,
      bool allowUnderscore = false,
      List<String> hostWhitelist = const [],
      List<String> hostBlacklist = const []}) {
    if (str == null ||
        str.isEmpty ||
        str.length > 2083 ||
        str.startsWith('mailto:')) {
      return false;
    }

    var protocol,
        user,
        auth,
        host,
        hostname,
        port,
        port_str,
        path,
        query,
        hash,
        split;

    // check protocol
    split = str.split('://');
    if (split.length > 1) {
      protocol = _shift(split);
      if (!protocols.contains(protocol)) {
        return false;
      }
    } else if (requireProtocol == true) {
      return false;
    }
    str = split.join('://');

    // check hash
    split = str!.split('#');
    str = _shift(split);
    hash = split.join('#');
    if (hash != null && hash != "" && RegExp(r'\s').hasMatch(hash)) {
      return false;
    }

    // check query params
    split = str!.split('?');
    str = _shift(split);
    query = split.join('?');
    if (query != null && query != "" && RegExp(r'\s').hasMatch(query)) {
      return false;
    }

    // check path
    split = str!.split('/');
    str = _shift(split);
    path = split.join('/');
    if (path != null && path != "" && RegExp(r'\s').hasMatch(path)) {
      return false;
    }

    // check auth type urls
    split = str!.split('@');
    if (split.length > 1) {
      auth = _shift(split);
      if (auth.indexOf(':') >= 0) {
        auth = auth.split(':');
        user = _shift(auth);
        if (!RegExp(r'^\S+$').hasMatch(user)) {
          return false;
        }
        if (!RegExp(r'^\S*$').hasMatch(user)) {
          return false;
        }
      }
    }

    // check hostname
    hostname = split.join('@');
    split = hostname.split(':');
    host = _shift(split);
    if (split.length > 0) {
      port_str = split.join(':');
      try {
        port = int.parse(port_str, radix: 10);
      } catch (e) {
        return false;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(port_str) ||
          port <= 0 ||
          port > 65535) {
        return false;
      }
    }

    if (!_isIP(host) &&
        !_isFQDN(host,
            requireTld: requireTld, allowUnderscores: allowUnderscore) &&
        host != 'localhost') {
      return false;
    }

    if (hostWhitelist.isNotEmpty && !hostWhitelist.contains(host)) {
      return false;
    }

    if (hostBlacklist.isNotEmpty && hostBlacklist.contains(host)) {
      return false;
    }

    return true;
  }

  static bool _isIP(String? str, [/*<String | int>*/ version]) {
    version = version.toString();
    if (version == 'null') {
      return _isIP(str, 4) || _isIP(str, 6);
    } else if (version == '4') {
      if (!_ipv4Maybe.hasMatch(str!)) {
        return false;
      }
      var parts = str.split('.');
      parts.sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    }
    return version == '6' && _ipv6.hasMatch(str!);
  }

  /// check if the string [str] is a fully qualified domain name (e.g. domain.com).
  ///
  /// * [requireTld] sets if TLD is required
  /// * [allowUnderscore] sets if underscores are allowed
  static bool _isFQDN(String str,
      {bool requireTld = true, bool allowUnderscores = false}) {
    var parts = str.split('.');
    if (requireTld) {
      var tld = parts.removeLast();
      if (parts.isEmpty || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
        return false;
      }
    }

    for (var part in parts) {
      if (allowUnderscores) {
        if (part.contains('__')) {
          return false;
        }
      }
      if (!RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
        return false;
      }
      if (part[0] == '-' ||
          part[part.length - 1] == '-' ||
          part.contains('---')) {
        return false;
      }
    }
    return true;
  }

  static _shift(List l) {
    if (l.isNotEmpty) {
      var first = l.first;
      l.removeAt(0);
      return first;
    }
    return null;
  }
}
