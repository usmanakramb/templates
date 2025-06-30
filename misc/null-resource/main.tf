resource "null_resource" "null1" {
  provisioner "local-exec" {
    command = "echo This command will execute whenever the configuration changes"
  }
}
