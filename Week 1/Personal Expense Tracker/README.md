# Personal Expense Tracker

A menu-driven command-line app to log daily expenses, categorize them, track spending against a monthly budget, and save/load everything to CSV.

```bash
python3 expense_tracker.py
```

No third-party packages needed (Python 3.8+).

## Features

| Menu option | What it does |
|---|---|
| 1. Add expense | Asks for date (`YYYY-MM-DD`, blank = today), category, amount and description; stores it as a dictionary, e.g. `{'date': '2024-09-18', 'category': 'Food', 'amount': 15.5, 'description': 'Lunch with friends'}` |
| 2. View expenses | Lists all expenses, skips and flags incomplete entries, and shows totals per category |
| 3. Track budget | Asks for a monthly budget (first time), compares this month's spending, and warns when it is exceeded or shows what is left |
| 4. Save expenses | Writes all expenses to `expenses.csv` (one row each: date, category, amount, description) |
| 5. Exit | Saves and quits |

On start-up the app reloads `expenses.csv` (and the saved budget) so you continue where you left off.

## Example

```
===== Personal Expense Tracker =====
1. Add expense
2. View expenses
3. Track budget
4. Save expenses
5. Exit
Choose an option (1-5): 3
Spent this month (2026-10): 135.50 of 100.00
WARNING: You have exceeded your budget by 35.50!
```

Input is validated: invalid dates or non-positive amounts are re-prompted.
