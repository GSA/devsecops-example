data "aws_region" "current" {
  current = true
}

resource "aws_vpc" "drupal" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "Drupal"
  }
}

# one per region
resource "aws_subnet" "drupal_a" {
  vpc_id = "${aws_vpc.drupal.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true
  tags {
    Name = "Drupal subnet A"
  }
}
resource "aws_subnet" "drupal_b" {
  vpc_id = "${aws_vpc.drupal.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${data.aws_region.current.name}b"
  map_public_ip_on_launch = true
  tags {
    Name = "Drupal subnet B"
  }
}
