resource "aws_db_subnet_group" "drupal" {
  name = "drupal"
  description = "Database subnet group"
  subnet_ids = ["${aws_subnet.drupal_a.id}", "${aws_subnet.drupal_b.id}"]
}

resource "aws_db_instance" "drupal" {
  allocated_storage = 10
  # https://www.drupal.org/docs/8/system-requirements/database-requirements
  engine = "postgres"
  engine_version = "9.6.2"
  instance_class = "db.t2.micro"
  name = "drupal"
  username = "drupaluser"
  password = "drupalpass"
  db_subnet_group_name = "${aws_db_subnet_group.drupal.name}"
}
