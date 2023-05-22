import random
import string

def generate_sql_statement():
  """Generates a random SQL statement."""
  statement = ""
  for i in range(random.randint(1, 10)):
    statement += random.choice(string.ascii_letters)
  return statement

def fuzz_sqlite(database_file):
  """Fuzzes the SQLite database file.

  Args:
    database_file: The path to the SQLite database file.
  """
  connection = sqlite3.connect(database_file)
  while True:
    sql_statement = generate_sql_statement()
    try:
      connection.execute(sql_statement)
    except sqlite3.Error as e:
      print(e)

if __name__ == "__main__":
  database_file = "test.sqlite"
  fuzz_sqlite(database_file)
