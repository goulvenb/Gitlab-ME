# Gitlab ME (My Edition)

My own Gitlab CE (Community Edition) install.

## Features

- Forced SSO/SAML.
  - It is not possible to Register nor Login using Passwords.
  - It is not possible to access public repos without being logged-in.
  - Disabling HTTPS cloning and pushing using a password (as users should not have one thanks to SSO) ; However, they can still do so using a PAT or a SSH key.
- Container Registry.
- Automated Gitlab Rails console.
  - To change default settings without needing to connect to the admin 
  - Inside [`init.rb`](./init.rb) console.
- Backups.
  - Automatic Backups with `cron`.

## Initialization

Before starting the container, you need to put the SSL Certificate of both the Gitlab domain name and the Registry domain name in the [`./certs`](./certs) directory.

You need to store both the Private key (`.key`) and the Certificate (`.crt`) in the form of `./certs/DOMAIN_NAME/DOMAIN_NAME.key` and `./certs/DOMAIN_NAME/DOMAIN_NAME.crt`.

For example, you could have the following tree :

```
certs
├── registry.git.internal
│   ├── registry.git.internal.crt
│   └── registry.git.internal.key
└── git.internal
    ├── git.internal.crt
    └── git.internal.key
```

## Installation

Copy [`.env.example`](./.env.example) into `.env` and adapt the values.

Read and understand the values inside [`gitlab.rb`](./gitlab.rb) and [`init.rb`](./init.rb) and adapt them if needed.

Then, you can run :

```sh
docker-compose up -d
```

## Runners

Before starting, you need to put your CA certificate in `./certs/ca.crt`.

Once that's done, you can simply do the following :

```sh
docker-compose -f docker-compose.runners.yaml up -d
```