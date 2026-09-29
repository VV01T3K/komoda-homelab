# komoda-homelab

Docker Compose homelab split into `core`, `internum`, and `externum` stacks, with deployment centered around Komodo.

## Layout

- `core/` shared infrastructure: `dns` (AdGuard + Unbound), `proxy` (Caddy), `valkey`
- `internum/` internal services: Authelia, Homepage, Gitea, n8n, Open WebUI, llama, Uptime Kuma, Excalidraw, IT-Tools, Beszel
- `externum/` internet-facing edge/services: Caddy, Cloudflared, CrowdSec, CloudBeaver, HyperDX, public Uptime Kuma, Frog keepalive

## Notes

- Each app lives in its own folder with a local `compose.yaml`
- Komodo is not defined here; `core/komo.do`, `internum/komo.do`, and `externum/komo.do` note manual installation
- Some stacks expect local `.env` files
- Shared external Docker networks used in the repo include `proxy`, `backend`, `crowdsec`, `cloudflare`, and `hyperdx`
- Caddy is configured through Docker labels and uses wildcard TLS via Cloudflare DNS
- Certificates are shared through Valkey-backed Caddy storage

## Network

Hosts sit on VLANs routed by a UniFi UCG Ultra (zone-based firewall):

| VLAN | Network | Subnet | Hosts |
|---|---|---|---|
| 1 | Management | `10.1.0.0/24` | UCG `10.1.0.1`, Proxmox `10.1.0.2` |
| 10 | Personal | `10.0.0.0/24` | Wi-Fi clients |
| 20 | Infra | `10.2.0.0/24` | `core` (komoda) `10.2.0.53`, `externum` `10.2.0.100`, `internum` `10.2.0.101` |

- The stack LXCs are tagged VLAN 20 on the VLAN-aware `vmbr0` bridge in Proxmox
- Management and Personal can reach Infra; Infra cannot open connections to Management or Personal unless the UCG has an explicit allow policy (e.g. `core` -> Proxmox `:8006` for `proxmox.lab.wsiwiec.com`)
- Host records live in the AdGuard rewrites in `core/dns/adguard/AdGuardHome.template.yaml`

## Deploy

1. Create the required Docker networks.
2. Add the needed `.env` files for stacks that reference them.
3. Deploy selected `compose.yaml` files with Docker Compose or Komodo.
4. Use [`trigger-komodo-webhook.sh`](./trigger-komodo-webhook.sh) to trigger a Komodo webhook from CI.
