# Traefik Docker Compose Setup

This project provides a ready-to-use **Traefik v3 reverse proxy** configuration using Docker Compose for **local development** and **production deployments**.

Traefik automatically:
- Discovers your Docker containers
- Routes HTTP and HTTPS traffic
- Issues free Let's Encrypt TLS certificates

---

## Quick Start

```bash
# Development
make up-dev      # Start dev environment

# Production (first time setup)
make setup-prod  # Create letsencrypt directory (required before first run)
make up-prod     # Start production environment
```

---

## Project Structure

```
.
├── docker-compose-local.yml     # Local development configuration
├── docker-compose-prod.yml      # Production configuration
├── letsencrypt/                 # Stores Let's Encrypt certificates
├── Makefile                     # Convenient management commands
├── .gitignore                   # Git exclusions
└── README.md
```

---

## Requirements

- Docker Engine 20.10+
- Docker Compose V2 (using `docker compose`, not `docker-compose`)
- (Optional) GNU Make for convenient commands
- User must have Docker permissions (see Troubleshooting)

---

## 🛠️ Local Development

By default, the development stack:

- Exposes Traefik dashboard (insecure) on port `8080`
- Routes HTTP traffic on port `8000`
- Logs in debug mode
- Does **not** redirect HTTP to HTTPS

### Common Development Commands

```bash
make up-dev        # Start development stack
make down-dev      # Stop development stack
make restart-dev   # Restart development stack
make logs-dev      # View logs (follow mode)
make ps-dev        # Show container status
```

### Access Traefik Dashboard

Visit [http://localhost:8080](http://localhost:8080)

> ⚠️ **Note:** The insecure dashboard is enabled for development only. Do not enable it in production.

---

## 🌐 Production Deployment

The production configuration:

* Exposes ports `80` and `443`
* Automatically issues Let's Encrypt certificates
* Redirects HTTP to HTTPS
* Does **not** expose the dashboard
* Uses `restart: always` for high availability

### Before deploying:

1. **Initialize Let's Encrypt directory** (one-time setup):

   ```bash
   make setup-prod
   ```

2. **Update the email address** for Let's Encrypt registration in `docker-compose-prod.yml`:

   ```yaml
   - "--certificatesresolvers.myresolver.acme.email=you@example.com"
   ```

### Common Production Commands

```bash
make up-prod       # Start production stack
make down-prod     # Stop production stack
make restart-prod  # Restart production stack
make logs-prod     # View logs (follow mode)
make ps-prod       # Show container status
make status        # Show all stacks status
```

---

## 📂 Makefile Commands

Run `make` or `make help` to see all available commands.

### Development Commands
| Command           | Description                        |
| ----------------- | ---------------------------------- |
| `make up-dev`     | Start development stack            |
| `make down-dev`   | Stop development stack             |
| `make restart-dev`| Restart development stack          |
| `make logs-dev`   | Show logs (follow mode)            |
| `make ps-dev`     | Show dev container status          |
| `make clean-dev`  | Stop dev and remove volumes        |

### Production Commands
| Command           | Description                        |
| ----------------- | ---------------------------------- |
| `make up-prod`    | Start production stack             |
| `make down-prod`  | Stop production stack              |
| `make restart-prod`| Restart production stack          |
| `make logs-prod`  | Show logs (follow mode)            |
| `make ps-prod`    | Show prod container status         |
| `make clean-prod` | Stop prod and remove volumes       |
| `make setup-prod` | Initialize letsencrypt directory   |

### Maintenance Commands
| Command           | Description                        |
| ----------------- | ---------------------------------- |
| `make pull-dev`   | Pull latest dev images             |
| `make pull-prod`  | Pull latest prod images            |
| `make pull-all`   | Pull all images                    |
| `make status`     | Show all container statuses        |
| `make help`       | Show help menu                     |

---

## 🧭 Adding Your Applications

To have Traefik route traffic to your apps:

1. **Join the `vps-traefik` network:**

   ```yaml
   networks:
     - vps-traefik
   ```

2. **Add labels to configure routing:**

   Example (docker-compose):

   ```yaml
   labels:
     - "traefik.enable=true"
     - "traefik.http.routers.myapp.rule=Host(`yourdomain.com`)"
     - "traefik.http.routers.myapp.entrypoints=websecure"
     - "traefik.http.routers.myapp.tls.certresolver=myresolver"
   ```

---

## 🛡️ Security Tips

* **Never** enable `--api.insecure=true` in production
* Use a staging Let's Encrypt server for testing to avoid rate limits
* Always mount Docker socket as read-only (`:ro`)
* Use strong TLS configurations
* Keep `letsencrypt/acme.json` permissions at `600`
* Never commit `letsencrypt/` directory or `.env` files to git

---

## 🔧 Troubleshooting

### Docker Permission Denied

If you encounter `permission denied while trying to connect to the Docker daemon socket`:

**Option 1: Add your user to docker group (recommended)**
```bash
sudo usermod -aG docker $USER
newgrp docker  # Apply immediately
```

**Option 2: Use sudo**
```bash
sudo make up-prod
```

### Let's Encrypt Certificate Issues

- **Rate limits**: Use staging server for testing
- **Domain not pointing to server**: Ensure DNS is configured correctly
- **Firewall blocking ports 80/443**: Open required ports
- **File permissions**: Ensure `acme.json` has `600` permissions

### Container Not Starting

```bash
# Check container status
make status

# View logs for errors
make logs-prod  # or make logs-dev

# Restart containers
make restart-prod  # or make restart-dev
```

---

## ✨ License

This project is open source and available under the [MIT License](LICENSE).

---

## 💡 Questions?

Feel free to open an issue or ask for help!
