variable "port" {
  description = "The port the application will run on"
  type        = number
}

variable "app_env" {
  description = "The environment the application will run in"
  type        = string
}

variable "db_host" {
  description = "The host of the database"
  type        = string
}

variable "db_port" {
  description = "The port of the database"
  type        = number
}

variable "db_database" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The username to connect to the database"
  type        = string
}

variable "db_password" {
  description = "The password to connect to the database"
  type        = string
}

variable "db_schema" {
  description = "The schema of the database"
  type        = string
}

variable "github_ref_name" {
  description = "The name of the branch or tag in the GitHub repository"
  type        = string
}

variable "database_url" {
  description = "The URL of the database"
  type        = string
}

variable "jwt_secret" {
  description = "The secret to sign the JWT token"
  type        = string
}
