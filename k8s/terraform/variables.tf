# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "mycluster"
}
variable "url_site" {
  description = "Domain name"
  type        = string
  default     = "yp3yp3.site" # Replace with your actual domain
  
}