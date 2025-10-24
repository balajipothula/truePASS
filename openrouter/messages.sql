CREATE TABLE IF NOT EXISTS user (
  content TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS assistant (
  content TEXT NOT NULL
);

INSERT INTO user (content) VALUES (
  'Provide a single, fully functional cURL command to create a Cloudflare D1 database, including all required headers and JSON payload. Only output the cURL command.'
);

SELECT rowid, content FROM user;