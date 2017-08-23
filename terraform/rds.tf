resource "aws_db_instance" "drupal" {
  allocated_storage = 10
  # https://www.drupal.org/docs/8/system-requirements/database-requirements
  engine = "postgres"
  engine_version = "9.6.2"
  instance_class = "db.t2.micro"
  # just for development
  skip_final_snapshot = true

  name = "drupal"
  username = "drupaluser"
  password = "drupalpass"

  db_subnet_group_name = "${module.vpc.database_subnet_group}"
  vpc_security_group_ids = ["${aws_security_group.drupal_db.id}"]
}
