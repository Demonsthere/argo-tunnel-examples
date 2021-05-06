# Access application to apply zero trust policy over SSH endpoint
resource "cloudflare_access_application" "ssh_app" {
  zone_id          = var.cloudflare_zone_id
  name             = "Access protection for ssh.${var.cloudflare_zone}"
  domain           = "ssh.${var.cloudflare_zone}"
  session_duration = "1h"
}

# Access policy that the above appplication uses. (i.e. who is allowed in)
resource "cloudflare_access_policy" "ssh_policy" {
  application_id = cloudflare_access_application.ssh_app.id
  zone_id        = var.cloudflare_zone_id
  name           = "Example Policy for ssh.${var.cloudflare_zone}"
  precedence     = "1"
  decision       = "allow"

  include {
    email = [var.cloudflare_email]
  }
}

# Adding in a short lived SSH certificate; guide can be found at https://developers.cloudflare.com/cloudflare-one/tutorials/ssh-cert-bastion
resource "cloudflare_access_ca_certificate" "ssh_short_key" {
  zone_id        = var.cloudflare_zone_id
  application_id = cloudflare_access_application.ssh_app.id
}