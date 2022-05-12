# Feature wishlist
* look into regional undo
* add check to see if current line is a valid undo line format
    * once that's done, add metadata, like "YOU ARE HERE" and "w"
* fuzzy finding in the undo history
* something like {range}Gclog

## Restoring changes
* I often find myself deleting a chunk of code and then later wishing I still
  had it. I could press u a bunch of times, but then I have to be careful to
  not split the undo branch before I redo it all back. In general, not ideal.
* Ref: JetBrains "restore changes"
    * The restored change is a new undo entry

## Tracking project files?
* Using what's in `undodir`, we can see all files that no longer exist (that we
  may be able to restore)

## Discoverability and Help
Imagine, press a key (eg. `?`) over a line, and a popup (think diagnostic
popup) shows up and tells you what actions are available (for that line!) in addition to a bit
of info. And links to where you can read more (`see :h abcd`).

# API Wishlist
nvim api funcs that would make this easier
get undotree of a specific file or buffer (nvim_get_undotree)
nvim_get_undo, get the lines for a specific undo seq of a specific buffer. pass in 0 for seq_cur


