resource "null_resource" "null" {
  provisioner "local-exec" {
    command = "echo This command will execute whenever the configuration changes"
  }
}
