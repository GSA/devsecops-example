resource "aws_ebs_volume" "main" {
  availability_zone = "${var.az}"
  type = "gp2"
  size = 10
  encrypted = true

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_instance" "main" {
  instance_id = "${var.instance_id}"
}

locals {
  script_dest = "/tmp/attach-data-volume.sh"
}

resource "aws_volume_attachment" "main" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.main.id}"
  instance_id = "${var.instance_id}"

  # https://github.com/hashicorp/terraform/issues/2740#issuecomment-288549352
  skip_destroy = true

  connection {
    user = "${var.ssh_user}"
    host = "${var.ssh_host == "" ? data.aws_instance.main.public_ip : var.ssh_host}"
  }

  provisioner "file" {
    source      = "${path.module}/files/attach-data-volume.sh"
    destination = "${local.script_dest}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.script_dest}",
      "DEVICE=${var.device} OWNER=${var.owner} DEST=${var.mount_dest} CHECK_DIR=${var.mount_dest}/${var.check_dir} ${local.script_dest}"
    ]
  }
}
