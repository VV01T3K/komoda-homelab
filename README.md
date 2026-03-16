# komoda-homelab

Docker Compose homelab split into `core`, `internum`, and `externum` stacks, with deployment centered around Komodo.

## Layout

- `core/` shared infrastructure: `dns` (AdGuard + Unbound), `proxy` (Caddy), `valkey`
- `internum/` internal services: Authelia, Homepage, Gitea, n8n, Open WebUI, llama, Uptime Kuma, Excalidraw, IT-Tools, Beszel
- `externum/` internet-facing edge/services: Caddy, Cloudflared, CrowdSec, CloudBeaver, public Uptime Kuma

## Notes

- Each app lives in its own folder with a local `compose.yaml`
- Komodo is not defined here; `core/komo.do`, `internum/komo.do`, and `externum/komo.do` note manual installation
- Some stacks expect local `.env` files
- Shared external Docker networks used in the repo include `proxy`, `backend`, `crowdsec`, and `cloudflare`
- Caddy is configured through Docker labels and uses wildcard TLS via Cloudflare DNS
- Certificates are shared through Valkey-backed Caddy storage

## Deploy

1. Create the required Docker networks.
2. Add the needed `.env` files for stacks that reference them.
3. Deploy selected `compose.yaml` files with Docker Compose or Komodo.
4. Use [`trigger-komodo-webhook.sh`](./trigger-komodo-webhook.sh) to trigger a Komodo webhook from CI.
