locals {
  timestamp  = timestamp()
  yyyymmdd   = formatdate("YYYY/MM/DD",          local.timestamp)   
  datetime   = formatdate("YYYY-MM-DD-HH-mm-ss", local.timestamp)
}
