####################################################################################
###                                   VARIABLES                                  ###
####################################################################################
enable_saml = !"#{ENV['SAML_IDP_CERT_FINGERPRINT']}".to_s.strip.empty? && !"#{ENV['SAML_IDP_SSO_TARGET_URL']}".to_s.strip.empty?
enable_registry = !"#{ENV['DOMAIN_GITLAB_REGISTRY']}".to_s.strip.empty?

####################################################################################
###                                OMNIBUS CONFIG                                ###
###==============================================================================###
### url: https://docs.gitlab.com/omnibus/settings/configuration.html             ###
####################################################################################
## Basic
# Domain name
external_url "https://#{ENV['DOMAIN_GITLAB']}"
# Timezone
# Necessary for both the date format of backups
# And the time shown on commits
gitlab_rails["time_zone"] = "#{ENV['TZ']}"
# Disabling access of public repos
# to non-connected users
gitlab_pages["access_control"] = true
# Needed for HTTPS
# (And HTTPS is mandatory)
nginx["ssl_certificate"] = "/certs/#{ENV['DOMAIN_GITLAB']}/#{ENV['DOMAIN_GITLAB']}.crt"
nginx["ssl_certificate_key"] = "/certs/#{ENV['DOMAIN_GITLAB']}/#{ENV['DOMAIN_GITLAB']}.key"
## SSH
# Domain name
# most of the time the same as the domain of the app
gitlab_rails["gitlab_ssh_host"] = "#{ENV['DOMAIN_GITLAB']}"
# SSH port
# Only affect the text shown when cloning with SSH
# And not the actual SSH port
gitlab_rails["gitlab_shell_ssh_port"] = "#{ENV['SSH_PORT']}"
## Container Registry
registry_nginx["enable"] = enable_registry
registry["enable"] = enable_registry
gitlab_rails["registry_enabled"] = enable_registry
if (enable_registry)
    # Domain name
    registry_external_url "https://#{ENV['DOMAIN_GITLAB_REGISTRY']}"
    # Mandatory
    gitlab_rails["registry_path"] = "/var/opt/gitlab/gitlab-rails/shared/registry"
    registry_nginx["ssl_certificate"] = "/certs/#{ENV['DOMAIN_GITLAB_REGISTRY']}/#{ENV['DOMAIN_GITLAB_REGISTRY']}.crt"
    registry_nginx["ssl_certificate_key"] = "/certs/#{ENV['DOMAIN_GITLAB_REGISTRY']}/#{ENV['DOMAIN_GITLAB_REGISTRY']}.key"
end
## SSO/SAML
# url: https://docs.gitlab.com/ee/integration/saml.html
if (enable_saml)
    gitlab_rails["omniauth_allow_single_sign_on"] = ["saml"]
    gitlab_rails["omniauth_block_auto_created_users"] = false
    gitlab_rails["omniauth_auto_link_saml_user"] = true
    gitlab_rails["omniauth_providers"] = [{
        name: "saml",
        label: "SSO Login",
        args: {
            assertion_consumer_service_url: "https://#{ENV['DOMAIN_GITLAB']}/users/auth/saml/callback",
            idp_cert_fingerprint: "#{ENV['SAML_IDP_CERT_FINGERPRINT']}",
            idp_sso_target_url: "#{ENV['SAML_IDP_SSO_TARGET_URL']}",
            issuer: "https://#{ENV['DOMAIN_GITLAB']}",
            name_identifier_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
        }
    }]
end
## Backups
#gitlab_rails["backup_path"] = "/backups"
# Automatically remove backups every 3 months
gitlab_rails["backup_keep_time"] = 7776000