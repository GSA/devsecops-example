resource "aws_db_instance" "wordpress" {
  allocated_storage = 10

  # https://wordpress.org/about/requirements/
  engine                = "mysql"
  engine_version        = "5.7.21"
  instance_class        = "db.t2.micro"
  copy_tags_to_snapshot = true

  # just for development
  skip_final_snapshot = true

  name     = "wordpress"
  username = "wordpressuser"
  password = "${var.db_pass}"

  db_subnet_group_name   = "${module.network.database_subnet_group}"
  vpc_security_group_ids = ["${aws_security_group.wordpress_db.id}"]

  lifecycle {
    prevent_destroy = true
  }
}
