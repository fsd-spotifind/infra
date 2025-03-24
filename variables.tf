variable "port" {
  description = "The port the application will run on"
  type        = number
}

variable "app_env" {
  description = "The environment the application will run in"
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
