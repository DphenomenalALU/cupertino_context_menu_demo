# cupertino_context_menu_demo

Demo app for `CupertinoContextMenu` (iOS-style “long-press” context menu that apps like WhatsApp and iMessage use).

## What this demo shows areal use-case
I created a simple list of Chats for this demo. You can long-press a chat to open a context menu with quick actions like Pin, Mute, and Delete (similar to iOS Messages).

## The 3 attributes (and what changes in my demo)
1) `CupertinoContextMenu.builder`  
   - Default behavior: uses the plain `child` as the preview.
   - Demo change: a custom preview card (rounded corners + shadow + extra “Preview” content).
   - Why I changed it: to show a richer preview that matches my Chat app.

2) `CupertinoContextMenuAction.trailingIcon`  
   - Default: `null` (no icon).
   - Demo change: icons appear on the right side of each action row.
   -Why I changed it: to make actions easier to scan quickly (“Pin”, “Mute”, “Delete”).

3) `CupertinoContextMenuAction.isDestructiveAction`  
   - Default: `false`.
   - Demo change: the Delete action becomes visually destructive (red styling).
   - Why I changed it: to warn users before they tap an irreversible action.

## Run instructions
Prereq: Flutter installed.

1) Get packages: `flutter pub get`  
2) Run: `flutter run`

## Screenshot
![Chats context menu demo](./docs/screenshot.png)

## Presentation date
In-class presentation date: March 4, 2026 (Wednesday)
