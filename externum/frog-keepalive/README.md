# Frog keepalive

Makes a restricted SSH login to Mikrus Frog roughly every 60 days. The
container generates its own dedicated key, pins the verified Frog host key,
and stores only the key and last-success timestamp in named Docker volumes.

## Setup

1. Copy `.env.template` to `.env` in your Docker dashboard and set
   `FROG_HOST_KEY_SHA256` to the fingerprint obtained from the owner's already
   trusted SSH client. Do not use an unverified `ssh-keyscan` result.
2. Deploy `compose.yaml`.
3. Copy the single `restrict,command="/usr/bin/uptime" ...` line from the
   container logs.
4. Log into Frog with the owner's normal key and append that line to
   `/home/frog/.ssh/authorized_keys`. Keep it on one line, then run:

   ```sh
   chmod 700 /home/frog/.ssh
   chmod 600 /home/frog/.ssh/authorized_keys
   ```

The container retries until the new public key is installed. Its first
successful login happens immediately; later successful logins become due 60
days afterward and receive up to six hours of random delay.

The login deliberately requests the command `false`. A correctly installed
`authorized_keys` restriction overrides it with `/usr/bin/uptime`, proving
that this key cannot execute arbitrary commands. Only then does the container
record the login as successful.

## Useful commands

Print the restricted public-key line again:

```sh
docker compose run --rm frog-keepalive public-key
```

Run an immediate validation without jitter:

```sh
docker compose run --rm frog-keepalive once
```

The private key remains in the `frog_keepalive_ssh` volume. Never copy it into
the repository, chat, logs, or screenshots. If Frog presents a different host
key later, the container stops instead of silently replacing the pinned key.

Keep a separate two-month calendar reminder until Mikrus confirms that
automated public-key logins reset Frog's inactivity timer.
