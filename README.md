# WordPress Bedrock + Sage + Vite Starter

🚀 A modern WordPress starter project powered by **Bedrock**, **Sage**,
**Vite**, and **TailwindCSS**.

This repo is intended to be used as a **template for starting new WordPress
sites** quickly with a modern development workflow.

---

## 📌 About This Repo

This repository is a **starter template** and should not be committed to
directly for custom site development.

When starting a new project:

- ✅ Clone this repo (or better yet, use "Use this template" on GitHub)
- ✅ Create a new GitHub repository for your project
- ✅ Customize the project as needed
- ✅ Commit your changes to your new project's repository

---

## 🛠️ Starting a New Project

### Environment Requirements

1. Ensure `mkcert` is installed (`brew install mkcert` on Mac) to generate SSL
   certs for local development. You can also run the `./scripts/setup-mkcert.sh`
   script if you're on a Mac if it's not once you've cloned the repo. It will
   handle everything.
2. Ensure you have a signing key set up in GitHub
   (https://github.com/settings/keys). I use an SSH key but GPG should work. If
   you don't have a signing key then the GitHub Action in
   .github/workflows/ci.yml will fail on your commits as it requires signed
   commits. If you don't want this ci.yml to run on commit, feel free to delete
   it from your new local/remote repos.
3. Make sure Docker is installed and running (on Mac, Docker Desktop is fine)
   since this all runs in Docker containers!

### Recommended (Template method)

1. Click the **"Use this template"** button on GitHub.
2. Create your new repository (this avoids Git history conflicts).
3. Clone your new repository locally.

### Alternative (Git Clone method)

```bash
git clone git@github.com:your-org/wordpress-bedrock-sage-starter.git my-new-site
cd my-new-site
rm -rf .git
git init
git remote add origin git@github.com:your-org/my-new-site.git
git add .
git commit -m "Initial commit from starter"
git push -u origin main
```

**After either of the above:**

1. Run the setup:

```bash
./setup.sh
```

2. Set up your .env file variables (see /.env file) since everything depends
   upon them
   - 🔒 YOU MUST Generate your keys here: https://roots.io/salts.html and put
     them in your .env file!
3. Check out the Makefile for a ton of utlity targets that do a number of things
4. To start the Vite server, do a `make dev` or `npm run dev` from your theme
   directory, but setup.sh will do this automatically for you the first time.
5. If you make a mess, you can run `make fresh-start`. This will:

- shut down any running Docker containers for this project
- prune and clean up docker
- rebuild docker images
- start docker images
- run composer/npm install steps in the images
- wait for Wordpress to initialize
- run initial setup of WordPress using .env variables (so you don't have to set
  up WordPress each time)
- run npm run dev to start vite server for hot reloading
- this is what ./setup.sh runs the first time

---

## 🔑 Key directories to work with:

- web/app/themes/your-theme-name/resources/ - Your source files
- web/app/themes/your-theme-name/public/ - Compiled assets
- web/app/themes/your-theme-name/resources/views/ - Blade templates
- web/app/themes/your-theme-name/resources/functions.php - Theme functions

---

## **Deployment:**

- Deploy to your staging/production environment
- Run `make deploy` from project root
- Make sure to set proper environment variables!

---

## 🧹 What NOT to do

- ❌ Do not commit site-specific code back to this starter repo
- ❌ Do not push commits to this repo unless improving the starter itself

---

## 📸 If you want to back up your database nightly

- open to the .github/workflows/db-backup.yml file
- uncomment the `schedule:` block and update the `cron` to whatever nightly (or
  whenever) time you like
- YOU MUST create the following GitHub repository secrets using the same values
  so your nightly DB backup will work
  - Go to GitHub > Repository (NOT ACCOUNT) Settings > Secrets and variables >
    Actions > Repository secrets
  - make the values match what you set in .env
  - DB_NAME
  - DB_USER
  - DB_PORT
  - DB_PASSWORD
- Copy relevant values from your .env file to the
  .github/workflows/db-backup.yml file, replacing all the 'get from .env or this
  action will fail' lines with the appropriate values.
- You have to do it this way since it uses docker-compose internally which you
  don't want to pass .env to a GitHub action if it contains secrets. Yes, you
  could split your .env but this is easier and takes 2 seconds.

## 📦 Features Included

- WordPress via Bedrock
- Sage theme + Blade templating
- Vite for JS/CSS bundling
- Tailwind CSS
- Laravel Blade components
- Docker Compose dev environment (optional)
- GitHub Actions for DB Backups (optional)

### Bedrock

Bedrock is a WordPress boilerplate from Roots that:

- Uses Composer to manage WordPress, plugins, and themes as PHP packages
- Moves WordPress core out of the web root (/web)
- Provides 12-Factor App structure: clean .env for configs (like Laravel)
- Makes deployment, security, and environment management way cleaner
- WordPress lives in /web/wp
- Your content (themes, plugins) lives in /web/app
- Config files are clean and environment-specific

| Bedrock Benefit            | Why It Matters                                                                  |
| -------------------------- | ------------------------------------------------------------------------------- |
| Composer-powered           | Update WordPress core, plugins, themes with version control                     |
| Secure folder structure    | No direct access to wp-config.php, WordPress code is outside /web public folder |
| .env environment variables | No more hardcoding DB credentials — easily switch between dev/stage/prod        |
| Cleaner deployments        | Git repositories stay lean, no need to commit plugins or WP itself              |
| Modern dev workflow        | Like Laravel, Symfony, Django apps                                              |
| Team collaboration         | Everyone installs the exact same setup via composer install                     |
| Easy CI/CD                 | Pull the repo, run composer install, and it’s deployed cleanly                  |

### Sage

- You can still create a child from Sage later, but usually not needed.
- Sage is NOT a child theme. It's a standalone theme that replaces both parent
  and child.

### Environment Breakdown

| Bedrock                                    | Sage                                          | Vite                                        |
| ------------------------------------------ | --------------------------------------------- | ------------------------------------------- |
| Project structure + environment management | WordPress theme (frontend + Blade templating) | Frontend bundler (JS/SCSS hot reload)       |
| Manages WordPress + plugins via Composer   | Lives inside /web/app/themes/sage-theme       | Runs inside Sage (via Bud/Vite integration) |
| .env config (DB, URLs)                     | Custom theme + Tailwind CSS, Blade templates  | Dev server for super-fast local dev         |

---

## 📄 License

MIT — use freely for client or commercial projects.

---

## 📬 Contributing to the Starter (not project-specific sites)

PRs welcome to improve the starter only (docs, tooling, boilerplate
improvements).
