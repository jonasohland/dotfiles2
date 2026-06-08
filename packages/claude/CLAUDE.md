# Global guidance

## Stopping background servers/processes — never `pkill -f`

`pkill -f <pattern>` (and any kill that matches a *full command line*) is unsafe in the Claude Code harness: `-f` also matches the sandbox-shell wrapper and the background-task supervisor that the Bash tool waits on to detect command completion. Signalling one of those leaves the foreground command unacknowledged, so it **hangs for many minutes** until the user aborts. The `[x]` bracket trick only avoids matching the command's own shell — it does nothing about the other wrapper processes.

Instead:
- Start long-running servers with the Bash tool's `run_in_background: true`, and stop them with the **`TaskStop`** tool, passing the background task id. Clean, instant, no shell signalling.
- If a shell kill is truly unavoidable, match the binary by **exact name only** (`pkill -x <binary>`), never `-f`. Wrappers are `bash`/harness processes and won't match.
- Plain `rm -rf <dir>` and other file cleanup is fine — it spawns no long-lived process and signals nothing.
