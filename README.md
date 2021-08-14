# Simple note to Standard note
Easily convert your notes from simple note to standard note format. Ported from [ruby](https://github.com/edas/simplenote2standardnote) to dart.

Requirements:
- `dart` (https://dart.dev/get-dart)
- `simplenote.json` (which contain your notes)

How to use:
- Place your `simplenote.json` in the same directory with `sim2stan.dart`.
- Run
```bash
dart pub get;
dart sim2stan.dart > standard.json;
```

After that you can just import this `standard.json` file from going into `Account`>`Data Backups`>`Import Backup`

License:  
`GNU Affero General Public License v3.0`
