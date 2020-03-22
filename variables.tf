# override default value or complete at runtime
variable "ssh_user" {
  type = string
  description = "ssh user add with public key to created compute"
}

# override default value or complete at runtime
variable "ssh_private_key_file" {
  type = string
  description = "path to ssh private key file"
}

# override default value or complete at runtime
variable "account_json_file" {
  type = string
  description = "path to json account file"
}

# override default value or complete at runtime
variable "source_allowed_ip" {
  type = string
  description = "source ip allow to access kubeapi port"
}

# override default value or complete at runtime
variable "project_id" {
  type = string
  description = "gcp project unique identifier"
}

variable "ssh_pub_key_file" {
  default = "~/.ssh/pub/id_rsa_bis.pub"
  type = string
  description = "path to ssh public key file"
}

variable "kube_master_tags" {
  default = ["kube-master"]
  type = list(string)
  description = "tags add to compute"
}

variable machine_type {
  default = "f1-micro"
  type = string
  description = "compute gabarit"
}

variable "region" {
  default = "us-east1"
  type = string
  description = "global region use by provider"
}

variable "zone" {
  default = "us-east1-b"
  type = string
  description = "global zone use by provider"
}

variable "cluster_name" {
  default = "mycluster"
  type = string
  description = "cluster_name"
}

variable "regex_ssh_config" {
  default = "Host gcp-1\\n *Hostname.*\\n *User.*"
  type = string
  description = "regex matching line to replace into"
}

// use locals instead of variable to allow variable interpolation
locals {
  value_ssh_config = "Host gcp-1\\n Hostname ${google_compute_address.external_address.address}\\n User ${var.ssh_user}"
}

variable "ssh_config_path" {
  default = "~/.ssh/config"
  type = string
  description = "path to ssh config for post provisionning"
}

variable "term_variable" {
  default = "konsole-256color"
  type = string
  description = "value of $TERM variable for post provisionning"
}

variable "remote_scripts" {
  // be careful trailing slash at the end mean content is copied but not folder
  default = "./provision/"
  type = string
  description = "list of script to copy and execute on compte post creation"
}