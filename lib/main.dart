import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pages/home_page.dart';

String markdown = """
# imap

This crate lets you connect to and interact with servers that implement the IMAP protocol ([RFC
3501](https://tools.ietf.org/html/rfc3501) and various extensions). After authenticating with
the server, IMAP lets you list, fetch, and search for e-mails, as well as monitor mailboxes for
changes. It supports at least the latest three stable Rust releases (possibly even older ones;
check the [CI
results](https://dev.azure.com/jonhoo/jonhoo/_build/latest?definitionId=11&branchName=master)).

**This crate is looking for maintainers — reach out to [@jonhoo] if you're interested.**

[@jonhoo]: https://thesquareplanet.com/

| Month    | Savings |
| -------- | ------- |
| January  | \$250    |
| February | \$80     |
| March    | \$420    |

## Running the test suite

To run the integration tests, you need to have [GreenMail
running](http://www.icegreen.com/greenmail/#deploy_docker_standalone). The
easiest way to do that is with Docker:

```console
\$ docker pull greenmail/standalone:1.6.8
\$ docker run -it --rm -e GREENMAIL_OPTS='-Dgreenmail.setup.test.all -Dgreenmail.hostname=0.0.0.0 -Dgreenmail.auth.disabled -Dgreenmail.verbose' -p 3025:3025 -p 3110:3110 -p 3143:3143 -p 3465:3465 -p 3993:3993 -p 3995:3995 greenmail/standalone:1.6.8
```

Another alternative is to test against cyrus imapd which is a more complete IMAP implementation that greenmail (supporting quotas and ACLs).

```
\$ docker pull outoforder/cyrus-imapd-tester
\$ docker run -it --rm -p 3025:25 -p 3110:110 -p 3143:143 -p 3465:465 -p 3993:993 outoforder/cyrus-imapd-tester:latest
```

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)
  at your option.

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
""";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.camera.status;
  if (status.isDenied) {
    await Permission.storage.onGrantedCallback(() async {
      runApp(const NotesApp());
    }).request();
  } else {
    runApp(const NotesApp());
  }
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
}
