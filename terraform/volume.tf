resource "aws_ebs_volume" "wp_content" {
  # TODO deletion protection
  availability_zone = "${data.aws_subnet.public.availability_zone}"
  size = 10
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
