resource "aws_db_instance" "wordpress" {
  allocated_storage = 10
  # https://wordpress.org/about/requirements/
  engine = "mysql"
  engine_version = "5.7.17"
  instance_class = "db.t2.micro"
  # just for development
  skip_final_snapshot = true

  name = "wordpress"
  username = "wordpressuser"
  password = "${var.db_pass}"

  db_subnet_group_name = "${module.vpc.database_subnet_group}"
  vpc_security_group_ids = ["${aws_security_group.wordpress_db.id}"]
}
