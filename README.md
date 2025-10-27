# Traefik Docker Compose Setup

This project provides a ready-to-use **Traefik v3 reverse proxy** configuration using Docker Compose for **local development** and **production deployments**.

Traefik automatically:
- Discovers your Docker containers
- Routes HTTP and HTTPS traffic
- Issues free Let's Encrypt TLS certificates

---

## Quick Start

```bash
# 1. Initialize environment (creates .env file)
make setup

# 2. Edit .env and set ENV=local or ENV=prod

# 3. If you set ENV=prod, run setup again to initialize Let's Encrypt
make setup

# 4. Start environment
make up
```

---

## Project Structure

```
.
├── docker-compose-local.yml     # Local development configuration
├── docker-compose-prod.yml      # Production configuration
├── letsencrypt/                 # Stores Let's Encrypt certificates
├── Makefile                     # Convenient management commands
├── .env.example                 # Example environment configuration
├── .gitignore                   # Git exclusions
└── README.md
```

---

## Environment Configuration

The project uses a `.env` file for environment switching. Create it with:

```bash
make setup
```

**Available variables:**
- `ENV` - Set to `local` or `prod` (default: `local`)
- `LETSENCRYPT_EMAIL` - Your email for Let's Encrypt certificates (production only)

**Example `.env`:**
```env
ENV=local
LETSENCRYPT_EMAIL=you@example.com
```

After editing `.env`, run `make setup` again if switching to production (it will create the letsencrypt directory).

Once configured, all commands automatically use the correct environment based on your `ENV` setting.

---

## Requirements

- Docker Engine 20.10+
- Docker Compose V2 (using `docker compose`, not `docker-compose`)
- (Optional) GNU Make for convenient commands
- User must have Docker permissions (see Troubleshooting)

---

## 🛠️ Local Development

The local development stack:

- Exposes Traefik dashboard (insecure) on port `8080`
- Routes HTTP traffic on port `8000`
- Logs in debug mode
- Does **not** redirect HTTP to HTTPS

**To use local environment:**

```bash
# Set ENV=local in .env file
echo "ENV=local" > .env

# Start
make up
```

**Access Traefik Dashboard:** [http://localhost:8080](http://localhost:8080)

> ⚠️ **Note:** The insecure dashboard is enabled for local development only. Do not enable it in production.

---

## 🌐 Production Deployment

The production configuration:

* Exposes ports `80` and `443`
* Automatically issues Let's Encrypt certificates
* Redirects HTTP to HTTPS
* Does **not** expose the dashboard
* Uses `restart: always` for high availability

### Before deploying:

1. **Initialize and configure** environment:

   ```bash
   make setup  # Creates .env file
   ```

2. **Edit .env** and set production environment:

   ```env
   ENV=prod
   LETSENCRYPT_EMAIL=you@example.com
   ```

3. **Run setup again** to initialize Let's Encrypt:

   ```bash
   make setup  # Creates letsencrypt directory for prod
   ```

### Start Production

```bash
make up        # Starts production (based on ENV=prod)
make logs      # View logs
make status    # Check status
```

---

## 📂 Makefile Commands

Run `make` or `make help` to see all available commands.

| Command           | Description                                      |
| ----------------- | ------------------------------------------------ |
| `make setup`      | Initialize environment (create .env, setup prod if needed) |
| `make up`         | Start environment (local or prod)                |
| `make down`       | Stop environment                                 |
| `make restart`    | Restart environment                              |
| `make logs`       | Show logs (follow mode)                          |
| `make ps`         | Show container status                            |
| `make clean`      | Stop and remove volumes                          |
| `make pull`       | Pull latest images                               |
| `make status`     | Show all stacks status                           |
| `make help`       | Show help menu                                   |

**Note:** All commands use the `ENV` variable from your `.env` file to determine which environment to use (local or prod).

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
