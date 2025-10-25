sqlite3 messages.sqlite3

CREATE TABLE IF NOT EXISTS user (
  content TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS assistant (
  content TEXT NOT NULL
);

SELECT rowid, content FROM user;

SELECT rowid, content FROM assistant;
