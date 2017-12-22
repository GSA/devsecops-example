data "aws_iam_role" "jenkins_master_role_arn" {
    role_name = "${module.jenkins_master_role.role_name}"
    }

resource "aws_ssm_patch_baseline" "jenkins_baseline" {
  name = "jenkins-patch-baseline"
  description = "jenkins patch baseline"
  operating_system = "REDHAT_ENTERPRISE_LINUX"

  approval_rule {
    approve_after_days = 0

    patch_filter {
      key    = "PRODUCT"
      values = ["RedhatEnterpriseLinux7.4"]
    }
    # Following filters may not work for Ubuntu
    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix", "Enhancement", "Recommended", "Newpackage"]
    }
  }
}

resource "aws_ssm_association" "ssm_jenkins_inventory_association" {
  name = "AWS-GatherSoftwareInventory"
  targets = {
      key    = "tag:Name"
      values = ["jenkins"]
      }
  schedule_expression = "cron(0 */30 * * * ? *)"
}

resource "aws_ssm_patch_group" "scan_patchgroup_static" {
  baseline_id = "${aws_ssm_patch_baseline.jenkins_baseline.id}"
  patch_group = "static"
}

resource "aws_ssm_patch_group" "scan_patchgroup_disposable" {
  baseline_id = "${aws_ssm_patch_baseline.jenkins_baseline.id}"
  patch_group = "disposable"
}

resource "aws_ssm_patch_group" "install_patchgroup_automatic" {
  baseline_id = "${aws_ssm_patch_baseline.jenkins_baseline.id}"
  patch_group = "automatic"
}

resource "aws_ssm_maintenance_window" "scan_window" {
  name     = "jenkins-patch-maintenance-scan-mw"
  schedule = "cron(0 */15 * * * ? *)"
  duration = "3"
  cutoff   = "1"
}

resource "aws_ssm_maintenance_window" "install_window" {
  name     = "jenkins-patch-maintenance-install-mw"
  schedule = "cron(0 */30 * * * ? *)"
  duration = "3"
  cutoff   = "1"
}

resource "aws_ssm_maintenance_window_target" "target_scan_static_disposable" {
  window_id     = "${aws_ssm_maintenance_window.scan_window.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["static", "disposable"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_scan_patches" {
  window_id        = "${aws_ssm_maintenance_window.scan_window.id}"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = 1
  service_role_arn = "${data.aws_iam_role.jenkins_master_role_arn.arn}"
  max_concurrency  = "20"
  max_errors       = "50"

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.target_scan_static_disposable.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Scan"]
  }

  logging_info {
    s3_bucket_name = "${aws_s3_bucket.ssm_jenkins_patch_log_bucket.id}"
    s3_region      = "${data.aws_region.current.name}"
  }
}

resource "aws_ssm_maintenance_window_target" "target_install" {
  window_id     = "${aws_ssm_maintenance_window.install_window.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["automatic"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_install_patches" {
  window_id        = "${aws_ssm_maintenance_window.install_window.id}"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = "${data.aws_iam_role.jenkins_master_role_arn.arn}"
  max_concurrency  = "20"
  max_errors       = "50"

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.target_install.*.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }

  logging_info {
    s3_bucket_name = "${aws_s3_bucket.ssm_jenkins_patch_log_bucket.id}"
    s3_region      = "${data.aws_region.current.name}"
  }
}