import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';

main() async {
  Map simplenotes = json.decode(
      File(Directory.current.path + '/simplenote.json').readAsStringSync());
  Map<String, List<Map<String, dynamic>>> standardnotes = {"items": []};
  Map<String, dynamic> tags = {};
  var NOW = DateTime.now().toIso8601String();

  Map<String, dynamic> convert(Map<String, dynamic> note,
      [bool trashed = false]) {
    String id = note['id']!;
    id.replaceAll('-', '');
    var uuid =
        "${id.substring(0, 8)}-${id.substring(8, 12)}-${id.substring(12, 16)}-${id.substring(16, 20)}-${id.substring(20, 32)}";
    late String preview;
    try {
      preview = note["content"]!.split("\n").sublist(0, 2).join(' ');
    } catch (e) {
      preview = note["content"]!.split("\n").sublist(0, 1).join(' ');
    }
    String content = note["content"]!;
    var title = (preview.trim().length > 40)
        ? preview.trim().substring(0, 41).trim() + "…"
        : preview.trim();
    if (note["tags"] != null)
      for (String tag in note["tags"] as List) {
        var t = tag.trim();
        if (t.isNotEmpty) {
          if (tags[t] == null) {
            tags.addAll(
              {
                t: {
                  "uuid": Uuid().v4(),
                  "content_type": "Tag",
                  "created_at": NOW,
                  "updated_at": NOW,
                  "content": {"title": tag, "references": []},
                },
              },
            );
          }
        }
        (tags[t]!['content']['references'] as List)
            .add({"uuid": uuid, "content_type": "Note"});
      }

    return {
      "uuid": uuid,
      "created_at": note["creationDate"],
      "updated_at": note["lastModified"],
      "content_type": "Note",
      "content": {
        "title": title.trim(),
        "text": content.trim(),
        "references": [],
        "trashed": trashed,
        "preview_plain": preview,
        "preview_html": null,
        "appData": {
          "org.standardnotes.sn": {"client_updated_at": note["lastModified"]}
        }
      }
    };
  }

  List<Map<String, dynamic>> activeNotes = [
    for (var note in simplenotes['activeNotes'])
      convert(Map<String, dynamic>.from(note))
  ];

  List<Map<String, dynamic>> trashedNotes = [
    for (var note in simplenotes['trashedNotes'])
      convert(Map<String, dynamic>.from(note), true)
  ];

  standardnotes["items"] = [...activeNotes, ...trashedNotes, ...tags.values];

  print(JsonEncoder.withIndent("  ").convert(standardnotes));
}
