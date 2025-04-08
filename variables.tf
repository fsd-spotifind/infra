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

variable "spotify_client_id" {
  description = "The Spotify client ID"
  type        = string
  sensitive = true
}

variable "spotify_client_secret" {
  description = "The Spotify client secret"
  type        = string
  sensitive = true
}
