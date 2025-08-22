variable "vm_name" {
  type    = string
  default = "win11"
}

variable "memory_mb" {
  type    = number
  default = 8192
}

variable "vcpu" {
  type    = number
  default = 4
}

variable "disk_size" {
  type    = number
  default = 80 # GB
}

variable "win_iso_path" {
  type        = string
  description = "Path to Windows 11 installer ISO"
}

variable "autounattend_iso_path" {
  type        = string
  description = "Path to Autounattend ISO containing Autounattend.xml and setup.ps1"
}

