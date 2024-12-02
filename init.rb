####################################################################################
###                                   VARIABLES                                  ###
####################################################################################
enable_saml = !"#{ENV['SAML_IDP_CERT_FINGERPRINT']}".to_s.strip.empty? && !"#{ENV['SAML_IDP_SSO_TARGET_URL']}".to_s.strip.empty?

####################################################################################
###                                 OTHER CONFIGS                                ###
###==============================================================================###
### This part is made to change default settings without needing to connect to   ###
###   the admin console.                                                         ###
### url: https://docs.gitlab.com/ee/administration/operations/rails_console.html ###
####################################################################################
## Login page
# Disabling signup as SSO/SAML automatically
# register new users, and Gitlab shall only
# be accessible through SSO/SAML
::Gitlab::CurrentSettings.update!(signup_enabled: (not enable_saml))
# Disabling password entirely as users
# should not have any thanks to SSO/SAML
::Gitlab::CurrentSettings.update!(password_authentication_enabled_for_web: (not enable_saml))
::Gitlab::CurrentSettings.update!(password_authentication_enabled_for_git: (not enable_saml))
# Removing the option to
# set a repo public
::Gitlab::CurrentSettings.update!(restricted_visibility_levels: ["public"])
## Default user settings
::Gitlab::CurrentSettings.update!(default_preferred_language: "fr")
::Gitlab::CurrentSettings.update!(first_day_of_week: 1)
## Security
# As password are disabled, the
# `root` account shall never be used
# so we remove it for security
User.delete(1)
# We disable the "Remember Me"
# Checkbox on login as it allow
# A browser to stay connected
# Indefinitely.
# url: https://docs.gitlab.com/ee/administration/settings/account_and_limit_settings.html#turn-remember-me-on-or-off
::Gitlab::CurrentSettings.update!(remember_me_enabled: false)
