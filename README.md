# Traefik Docker Compose Setup

This project provides a ready-to-use **Traefik v3 reverse proxy** configuration using Docker Compose for **local development** and **production deployments**.

Traefik automatically:
- Discovers your Docker containers.
- Routes HTTP and HTTPS traffic.
- Issues free Let's Encrypt TLS certificates.

---

### Project Structure

```

.
├── docker-compose.yml           # Local development configuration
├── docker-compose.prod.yml      # Production configuration
├── letsencrypt/                 # Stores certificates
├── Makefile                     # Convenient commands
└── README.md

````

---

### Requirements

- Docker Engine
- Docker Compose
- (Optional) GNU Make

---

### Local Development

By default, the development stack:

- Exposes Traefik dashboard (insecure) on port `8080`
- Routes HTTP traffic on port `8000`
- Logs in debug mode

### Start Local Stack

```bash
make up-dev
````

### Stop Local Stack

```bash
make down-dev
```

### View Logs

```bash
make logs-dev
```

### Access Traefik Dashboard

Visit [http://localhost:8080](http://localhost:8080)

> ⚠️ **Note:** Do not enable the insecure dashboard in production.

---

## 🌐 Production Deployment

The production configuration:

* Exposes ports `80` and `443`
* Automatically issues Let's Encrypt certificates
* Redirects HTTP to HTTPS
* Does **not** expose the dashboard

Before deploying:

1. Ensure `letsencrypt/` folder exists and is writable:

   ```bash
   mkdir -p letsencrypt
   touch letsencrypt/acme.json
   chmod 600 letsencrypt/acme.json
   ```

2. Update the email address for Let's Encrypt registration in `docker-compose.prod.yml`:

   ```yaml
   - "--certificatesresolvers.myresolver.acme.email=you@example.com"
   ```

### Start Production Stack

```bash
make up-prod
```

### Stop Production Stack

```bash
make down-prod
```

### View Logs

```bash
make logs-prod
```

---

## 📂 Makefile Commands

| Command          | Description                |
| ---------------- | -------------------------- |
| `make up-dev`    | Start development services |
| `make down-dev`  | Stop development services  |
| `make logs-dev`  | Follow logs (development)  |
| `make up-prod`   | Start production services  |
| `make down-prod` | Stop production services   |
| `make logs-prod` | Follow logs (production)   |
| `make help`      | Show help                  |

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

* **Never** enable `--api.insecure=true` in production.
* Use a staging Let's Encrypt server for testing (`acme.caserver`).
* Always mount Docker socket as read-only.
* Use strong TLS configurations.

---

## ✨ License

This project is open source and available under the [MIT License](LICENSE).

---

## 💡 Questions?

Feel free to open an issue or ask for help!

```

---

✅ **Would you like help tailoring this README further (e.g., adding badge icons, examples of app containers, or deployment instructions)?**
```
