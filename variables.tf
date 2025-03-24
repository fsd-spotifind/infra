variable "port" {
  description = "The port the application will run on"
  type        = number
}

variable "database_url" {
  description = "The URL of the database"
  type        = string
}

variable "jwt_secret" {
  description = "The secret to sign the JWT token"
  type        = string
  sensitive = true
}

