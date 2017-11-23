resource "aws_ebs_volume" "wp_content" {
  availability_zone = "${data.aws_subnet.public.availability_zone}"
  type = "gp2"
  size = 10
  encrypted = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "wp_content" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.wp_content.id}"
  instance_id = "${aws_instance.wordpress.id}"

  # https://github.com/hashicorp/terraform/issues/2740#issuecomment-288549352
  skip_destroy = true
  provisioner "remote-exec" {
    script = "files/attach-data-volume.sh"
    connection {
      user = "${var.ssh_user}"
      host = "${aws_eip.public.public_ip}"
    }
  }
}
