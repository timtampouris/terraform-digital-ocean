variable "digitalocean_token" {
  type        = "string"
  description = "DO token"
  default     = "YOUR_DO_TOKEN_HERE"
}

variable "ssh_fingerprints" {
  default = [
    "aa:62:c1:5d:3x:a6:a9:v8:fg:sb:n4:m7:51:n9:5f:s8",
    "a6:a9:v8:f6:45:98:m7:51:n9:5f:19:62:c1:5d:3x:a6",
  ]
}
