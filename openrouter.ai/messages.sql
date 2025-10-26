-- Open or create the SQLite3 database file named `messages.sqlite3`.
sqlite3 messages.sqlite3

-- Create a table named `user` if it doesn't already exist.
CREATE TABLE IF NOT EXISTS user (
  content TEXT NOT NULL
);

-- Create a table named `assistant` if it doesn't already exist.
CREATE TABLE IF NOT EXISTS assistant (
  content TEXT NOT NULL
);

-- Retrieve all records from the `user` table, including their internal row IDs.
SELECT rowid, content FROM user;

-- Retrieve all records from the `assistant` table along with their row IDs.
SELECT rowid, content FROM assistant;

-- Delete the record from the `user` table that has a row ID of 1.
DELETE FROM user WHERE rowid = 1;

-- Delete the record from the `assistant` table with a row ID of 1.
DELETE FROM assistant WHERE rowid = 1;

-- Remove all records from the `user` table.
DELETE FROM user;

-- Remove all records from the `assistant` table.
DELETE FROM assistant;

-- Permanently delete the `user` table from the database.
DROP TABLE user;

-- Permanently delete the `assistant` table from the database.
DROP TABLE assistant;
