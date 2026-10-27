"""Personal Expense Tracker.

A menu-driven command-line app to log daily expenses, categorize them,
track spending against a monthly budget, and save/load data to CSV.
"""

import csv
import os
from datetime import datetime

EXPENSES_FILE = "expenses.csv"
BUDGET_FILE = "budget.txt"
FIELDS = ["date", "category", "amount", "description"]

expenses = []          # list of dicts: {'date', 'category', 'amount', 'description'}
monthly_budget = None  # float or None


# ---------------------------------------------------------------- input helpers
def prompt_date():
    """Ask for a date in YYYY-MM-DD format; empty input means today."""
    while True:
        raw = input("Date (YYYY-MM-DD, blank for today): ").strip()
        if not raw:
            return datetime.today().strftime("%Y-%m-%d")
        try:
            datetime.strptime(raw, "%Y-%m-%d")
            return raw
        except ValueError:
            print("  Invalid date. Please use the format YYYY-MM-DD.")


def prompt_amount(label="Amount spent: "):
    """Ask for a positive number."""
    while True:
        raw = input(label).strip()
        try:
            value = float(raw)
            if value <= 0:
                raise ValueError
            return round(value, 2)
        except ValueError:
            print("  Please enter a positive number.")


def prompt_text(label):
    """Ask for non-empty text."""
    while True:
        value = input(label).strip()
        if value:
            return value
        print("  This field cannot be empty.")


# ---------------------------------------------------------------- 1. add expense
def add_expense():
    """Prompt for expense details and store it as a dictionary in the list."""
    print("\n--- Add Expense ---")
    expense = {
        "date": prompt_date(),
        "category": prompt_text("Category (e.g. Food, Travel): ").title(),
        "amount": prompt_amount(),
        "description": prompt_text("Description: "),
    }
    expenses.append(expense)
    print(f"Added: {expense}")


# ---------------------------------------------------------------- 2. view expenses
def is_valid(expense):
    """An entry is valid only if every required field is present and non-empty."""
    return all(str(expense.get(f, "")).strip() for f in FIELDS)


def view_expenses():
    """Loop through the expenses and display each valid entry."""
    print("\n--- All Expenses ---")
    if not expenses:
        print("No expenses recorded yet.")
        return
    print(f"{'#':<4}{'Date':<12}{'Category':<15}{'Amount':>10}  Description")
    print("-" * 60)
    skipped = 0
    for i, exp in enumerate(expenses, start=1):
        if not is_valid(exp):
            skipped += 1
            print(f"{i:<4}[incomplete entry skipped]")
            continue
        print(f"{i:<4}{exp['date']:<12}{exp['category']:<15}"
              f"{float(exp['amount']):>10.2f}  {exp['description']}")
    if skipped:
        print(f"\nNote: {skipped} incomplete entr{'y' if skipped == 1 else 'ies'} skipped.")

    # Bonus: totals per category
    totals = {}
    for exp in filter(is_valid, expenses):
        totals[exp["category"]] = totals.get(exp["category"], 0) + float(exp["amount"])
    print("\nTotal by category:")
    for cat, total in sorted(totals.items(), key=lambda kv: -kv[1]):
        print(f"  {cat:<15}{total:>10.2f}")


# ---------------------------------------------------------------- 3. budget
def set_budget():
    """Ask the user for their total monthly budget."""
    global monthly_budget
    monthly_budget = prompt_amount("Enter your total budget for the month: ")
    print(f"Monthly budget set to {monthly_budget:.2f}")


def total_expenses(month=None):
    """Sum all valid expenses, optionally only for a given 'YYYY-MM' month."""
    return sum(float(e["amount"]) for e in expenses
               if is_valid(e) and (month is None or e["date"].startswith(month)))


def track_budget():
    """Compare the current month's spending with the budget."""
    print("\n--- Track Budget ---")
    if monthly_budget is None:
        set_budget()
    month = datetime.today().strftime("%Y-%m")
    spent_month = total_expenses(month)
    spent_all = total_expenses()
    print(f"Total expenses recorded so far: {spent_all:.2f}")
    print(f"Spent this month ({month}): {spent_month:.2f} of {monthly_budget:.2f}")
    if spent_month > monthly_budget:
        print(f"WARNING: You have exceeded your budget by {spent_month - monthly_budget:.2f}!")
    else:
        print(f"You have {monthly_budget - spent_month:.2f} left for the month.")
    if input("Change budget? (y/N): ").strip().lower() == "y":
        set_budget()


# ---------------------------------------------------------------- 4. save / load
def save_expenses(path=EXPENSES_FILE):
    """Write every expense to a CSV file (one row per expense)."""
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(expenses)
    if monthly_budget is not None:
        with open(BUDGET_FILE, "w") as f:
            f.write(str(monthly_budget))
    print(f"Saved {len(expenses)} expense(s) to {path}")


def load_expenses(path=EXPENSES_FILE):
    """Load expenses from the CSV file back into the list at start-up."""
    global monthly_budget
    if os.path.exists(path):
        with open(path, newline="", encoding="utf-8") as f:
            for row in csv.DictReader(f):
                try:
                    row["amount"] = float(row["amount"])
                except (TypeError, ValueError):
                    row["amount"] = ""
                expenses.append(row)
        print(f"Loaded {len(expenses)} expense(s) from {path}")
    if os.path.exists(BUDGET_FILE):
        try:
            with open(BUDGET_FILE) as f:
                monthly_budget = float(f.read().strip())
        except ValueError:
            pass


# ---------------------------------------------------------------- 5. menu
def show_menu():
    print("\n===== Personal Expense Tracker =====")
    print("1. Add expense")
    print("2. View expenses")
    print("3. Track budget")
    print("4. Save expenses")
    print("5. Exit")


def main():
    load_expenses()
    actions = {"1": add_expense, "2": view_expenses, "3": track_budget, "4": save_expenses}
    while True:
        show_menu()
        try:
            choice = input("Choose an option (1-5): ").strip()
        except EOFError:
            choice = "5"
        if choice == "5":
            save_expenses()
            print("Goodbye!")
            break
        action = actions.get(choice)
        if action:
            action()
        else:
            print("Invalid choice, please enter a number from 1 to 5.")


if __name__ == "__main__":
    main()
