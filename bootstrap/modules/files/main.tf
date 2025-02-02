locals {
  file_type_flags = {
    pipeline          = "pipeline"
    pipeline_template = "pipeline_template"
    module            = "module"
    additional        = "additional"
  }
}

locals {
  starter_module_files = { for file in fileset(var.starter_module_folder_path, "**") : file => {
    path = "${var.starter_module_folder_path}/${file}"
    flag = local.file_type_flags.module
    }
  }
  pipeline_files = { for key, value in var.pipeline_files : value.target_path => {
    path = "${var.pipeline_folder_path}/${value.file_path}"
    flag = local.file_type_flags.pipeline
    }
  }
  template_files = { for key, value in var.pipeline_template_files : value.target_path => {
    path = "${var.pipeline_folder_path}/${value.file_path}"
    flag = local.file_type_flags.pipeline_template
    }
  }
  starter_module_repo_files = merge(local.starter_module_files, local.pipeline_files, local.template_files)
  additional_repo_files = { for file in var.additional_files : basename(file) => {
    path = file
    flag = local.file_type_flags.additional
    }
  }
  all_repo_files = merge(local.starter_module_repo_files, local.additional_repo_files)
}
