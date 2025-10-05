# Archive Lambda Function source code.
data "archive_file" "webapp" {
  type        = "zip"
  source_file = local.webapp_src
  output_path = "./${local.webapp_zip}"
}


locals {
  timestamp  = timestamp()
  yyyymmdd   = formatdate("YYYY/MM/DD",          local.timestamp)   
  datetime   = formatdate("YYYY-MM-DD-HH-mm-ss", local.timestamp)
  layer_zip  = "./python/lib/layer.zip"
  webapp_src = "./python/src/lambda_function.py"
  webapp_zip = "webapp-${local.datetime}.zip"
}
