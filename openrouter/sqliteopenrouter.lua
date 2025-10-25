#!/bin/redbean -i

sqlite3 = require('lsqlite3')

messages_db = sqlite3.open('/home/balaji/messages.sqlite3', sqlite3.OPEN_READWRITE)

for row in messages_db:nrows("SELECT name FROM sqlite_master WHERE type='table'") do
  print(row.name)
end

messages_db:close()
