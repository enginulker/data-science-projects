# Task Manager with User Authentication

A command-line task manager where each user registers and logs in; every user can only see and change their own tasks.

```bash
python3 task_manager.py
```

No third-party packages needed (Python 3.8+).

## Features

- **Registration** — unique usernames (case-insensitive check); passwords are **hashed with PBKDF2-HMAC-SHA256 + a random per-user salt** (200,000 iterations) before being stored in `data/users.json`. Plain-text passwords are never saved.
- **Login** — credentials are verified against the stored hash with a constant-time comparison. Password typing is hidden in a terminal.
- **Tasks** (stored per user in `data/tasks/<username>.json`):
  1. Add a Task — gets a unique ID and status `Pending`
  2. View Tasks — ID, description, status
  3. Mark a Task as Completed — by ID
  4. Delete a Task — by ID
  5. Logout — back to the welcome menu

## Example

```
===== Task Manager (alice) =====
Choose an option (1-5): 2

ID   Status      Description
--------------------------------------------------
1    Completed   Buy milk
2    Pending     Write report
```

`data/` is created automatically on first run (and is git-ignored).
