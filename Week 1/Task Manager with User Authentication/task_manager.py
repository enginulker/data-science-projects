"""Task Manager with User Authentication.

Users register/log in with a username and password (stored hashed with a
per-user salt using PBKDF2-SHA256). Each user's tasks are stored in their
own JSON file and only the logged-in user can access them.
"""

import getpass
import hashlib
import hmac
import json
import os
import secrets

DATA_DIR = "data"
USERS_FILE = os.path.join(DATA_DIR, "users.json")
TASKS_DIR = os.path.join(DATA_DIR, "tasks")
ITERATIONS = 200_000


# ---------------------------------------------------------------- storage helpers
def _ensure_dirs():
    os.makedirs(TASKS_DIR, exist_ok=True)


def _read_json(path, default):
    if not os.path.exists(path):
        return default
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def _write_json(path, data):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)


def load_users():
    return _read_json(USERS_FILE, {})


def save_users(users):
    _write_json(USERS_FILE, users)


def tasks_path(username):
    return os.path.join(TASKS_DIR, f"{username}.json")


def load_tasks(username):
    return _read_json(tasks_path(username), [])


def save_tasks(username, tasks):
    _write_json(tasks_path(username), tasks)


# ---------------------------------------------------------------- password hashing
def hash_password(password, salt=None):
    """Return (salt_hex, hash_hex) using PBKDF2-HMAC-SHA256."""
    salt = salt or secrets.token_bytes(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, ITERATIONS)
    return salt.hex(), digest.hex()


def verify_password(password, salt_hex, hash_hex):
    _, candidate = hash_password(password, bytes.fromhex(salt_hex))
    return hmac.compare_digest(candidate, hash_hex)


def ask_password(prompt="Password: "):
    # getpass hides typing in a real terminal; falls back to input() when piped
    try:
        return getpass.getpass(prompt) if os.isatty(0) else input(prompt)
    except (EOFError, KeyboardInterrupt):
        return ""


# ---------------------------------------------------------------- 1. authentication
def register():
    """Create a new user with a unique username and hashed password."""
    print("\n--- Register ---")
    users = load_users()
    username = input("Choose a username: ").strip()
    if not username or not username.isidentifier():
        print("Username must be non-empty and contain only letters, digits or _.")
        return None
    if username.lower() in (u.lower() for u in users):
        print("That username is already taken.")
        return None
    password = ask_password("Choose a password (min 4 chars): ")
    if len(password) < 4:
        print("Password too short.")
        return None
    if ask_password("Confirm password: ") != password:
        print("Passwords do not match.")
        return None
    salt, digest = hash_password(password)
    users[username] = {"salt": salt, "hash": digest}
    save_users(users)
    save_tasks(username, [])
    print(f"User '{username}' registered successfully. You can now log in.")
    return username


def login():
    """Validate credentials against the stored hash. Returns username or None."""
    print("\n--- Login ---")
    users = load_users()
    username = input("Username: ").strip()
    password = ask_password()
    record = users.get(username)
    if record and verify_password(password, record["salt"], record["hash"]):
        print(f"Welcome, {username}!")
        return username
    print("Invalid username or password.")
    return None


# ---------------------------------------------------------------- 2-5. task operations
def add_task(username):
    """Add a task with a unique ID and status 'Pending'."""
    description = input("Task description: ").strip()
    if not description:
        print("Description cannot be empty.")
        return
    tasks = load_tasks(username)
    new_id = max((t["id"] for t in tasks), default=0) + 1
    tasks.append({"id": new_id, "description": description, "status": "Pending"})
    save_tasks(username, tasks)
    print(f"Task #{new_id} added.")


def view_tasks(username):
    """Show all tasks for the logged-in user."""
    tasks = load_tasks(username)
    if not tasks:
        print("You have no tasks.")
        return
    print(f"\n{'ID':<5}{'Status':<12}Description")
    print("-" * 50)
    for t in tasks:
        print(f"{t['id']:<5}{t['status']:<12}{t['description']}")


def _ask_task_id():
    raw = input("Task ID: ").strip()
    return int(raw) if raw.isdigit() else None


def mark_completed(username):
    """Set a task's status to 'Completed' by its ID."""
    tasks = load_tasks(username)
    task_id = _ask_task_id()
    for t in tasks:
        if t["id"] == task_id:
            t["status"] = "Completed"
            save_tasks(username, tasks)
            print(f"Task #{task_id} marked as Completed.")
            return
    print("No task with that ID.")


def delete_task(username):
    """Remove a task by its ID."""
    tasks = load_tasks(username)
    task_id = _ask_task_id()
    remaining = [t for t in tasks if t["id"] != task_id]
    if len(remaining) == len(tasks):
        print("No task with that ID.")
        return
    save_tasks(username, remaining)
    print(f"Task #{task_id} deleted.")


# ---------------------------------------------------------------- 6. menus
def task_menu(username):
    actions = {"1": add_task, "2": view_tasks, "3": mark_completed, "4": delete_task}
    while True:
        print(f"\n===== Task Manager ({username}) =====")
        print("1. Add a Task\n2. View Tasks\n3. Mark a Task as Completed\n4. Delete a Task\n5. Logout")
        choice = input("Choose an option (1-5): ").strip()
        if choice == "5":
            print("Logged out.")
            return
        if choice in actions:
            actions[choice](username)
        else:
            print("Invalid choice.")


def main():
    _ensure_dirs()
    while True:
        print("\n===== Welcome =====")
        print("1. Register\n2. Login\n3. Exit")
        try:
            choice = input("Choose an option (1-3): ").strip()
        except EOFError:
            break
        if choice == "1":
            register()
        elif choice == "2":
            user = login()
            if user:
                task_menu(user)
        elif choice == "3":
            print("Goodbye!")
            break
        else:
            print("Invalid choice.")


if __name__ == "__main__":
    main()
