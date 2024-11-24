####################################################################################
###                                OMNIBUS CONFIG                                ###
###==============================================================================###
### url: https://docs.gitlab.com/omnibus/settings/configuration.html             ###
####################################################################################
## Basic
# Domain name
external_url "https://#{ENV['GITLAB_DOMAIN']}"
# Timezone
# Necessary for both the date format of backups
# And the time shown on commits
gitlab_rails["time_zone"] = "#{ENV['TZ']}"
# Disabling access of public repos
# to non-connected users
gitlab_pages['access_control'] = true
# Needed for HTTPS
# (And HTTPS is mandatory)
nginx['ssl_certificate'] = "/certs/#{ENV['GITLAB_DOMAIN']}/#{ENV['GITLAB_DOMAIN']}.crt"
nginx['ssl_certificate_key'] = "/certs/#{ENV['GITLAB_DOMAIN']}/#{ENV['GITLAB_DOMAIN']}.key"
## SSH
# Domain name
# most of the time the same as the domain of the app
gitlab_rails["gitlab_ssh_host"] = "#{ENV['GITLAB_DOMAIN']}"
# SSH port
# Only affect the text shown when cloning with SSH
# And not the actual SSH port
gitlab_rails["gitlab_shell_ssh_port"] = "#{ENV['SSH_PORT']}"
## Container Registry
# Domain name
registry_external_url "https://#{ENV['GITLAB_REGISTRY_DOMAIN']}"
# Mandatory
nginx["enable"] = true
registry_nginx["enable"] = true
registry["enable"] = true
gitlab_rails["registry_enabled"] = true
gitlab_rails["registry_path"] = "/var/opt/gitlab/gitlab-rails/shared/registry"
registry_nginx["ssl_certificate"] = "/certs/#{ENV['GITLAB_REGISTRY_DOMAIN']}/#{ENV['GITLAB_REGISTRY_DOMAIN']}.crt"
registry_nginx["ssl_certificate_key"] = "/certs/#{ENV['GITLAB_REGISTRY_DOMAIN']}/#{ENV['GITLAB_REGISTRY_DOMAIN']}.key"
## SSO/SAML
# url: https://docs.gitlab.com/ee/integration/saml.html
gitlab_rails["omniauth_allow_single_sign_on"] = ["saml"]
gitlab_rails["omniauth_block_auto_created_users"] = false
gitlab_rails["omniauth_auto_link_saml_user"] = true
gitlab_rails["omniauth_providers"] = [{
    name: "saml",
    label: "SSO Login",
    args: {
        assertion_consumer_service_url: "https://#{ENV['GITLAB_DOMAIN']}/users/auth/saml/callback",
        idp_cert_fingerprint: "#{ENV['SAML_IDP_CERT_FINGERPRINT']}",
        idp_sso_target_url: "#{ENV['SAML_IDP_SSO_TARGET_URL']}",
        issuer: "https://#{ENV['GITLAB_DOMAIN']}",
        name_identifier_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
    }
}]
## Backups
gitlab_rails['backup_path'] = '/backups'
# Automatically remove backups every 3 months
gitlab_rails['backup_keep_time'] = 7776000