# Custom WordPress Site Based on Roots Bedrock using Sage Theme and Vite

## Notes

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

## Initial Setup

- ensure `mkcert` is installed (`brew install mkcert` on Mac)
- ensure you have a signing key set up in GitHub (I use 1Password:
  https://developer.1password.com/docs/ssh/git-commit-signing/)
- run ./setup.zsh
- It will:
  - create an .env file from .env.example if not present
  - sets default database credentials
  - `composer install`
  - `cd web/app/themes/your-theme-name && composer install`
  - `cd web/app/themes/your-theme-name && npm install`
  - `docker-compose down`
  - `docker-compose build --no-cache`
  - `docker-compose up -d`
  - `npm --prefix web/app/themes/your-theme-name run dev`
  - resets wordpress username and password to one in .env
  - builds SSL certificates using mkcert (mkcert MUST BE INSTALLED!) and copies
    to docker
- 🔒 YOU MUST Generate your WordPress authentication keys and salts here:
  https://roots.io/salts.html and put them in the .env file!
- YOU MUST set your .env file up - everything in the project uses/depends upon
  it, except for:
  - .vscode/launch.json: you need to hard-code your xdebug port number to match
    what it is in .env

## Overview

1. **Local Development Setup:**

- Make sure Docker is running (since you're using Docker)
- Run `./setup.zsh`
  - This will copy the .env.example file to .env if it doesn't exist
  - YOU MUST CUSTOMIZE .env LOCALLY
  - It then calls `./scripts/setup.zsh` which runs the `make fresh-start` target
    and sets up HTTPS certificates
- Details of `make fresh-start`. This will:
  - shut down any running Docker containers for this project
  - prune and clean up docker
  - rebuild docker images
  - start docker images
  - run composer/npm install steps in the images
  - wait for Wordpress to initialize
  - run initial setup of WordPress using .env variables (so you don't have to
    set up WordPress each time)
  - run npm run dev to start vite server for hot reloading
- Access your site at http://localhost:8443 (or whatever port you've configured
  in WP_HTTPS_PORT in your .env file)

2. **Theme Development (Sage):**

- Navigate to web/app/themes/your-theme-name
- Run npm install to install theme dependencies (or use `make install`)
- Run npm run dev to start the Vite development server (or use `make dev`)
- This will give you:
  - Hot Module Replacement (HMR)
  - Live reloading
  - Source maps
  - Development optimizations

3. **WordPress Development:**

- Access WordPress admin at http://localhost/wp/wp-admin
- Set up your theme in WordPress
- Create necessary pages/posts
- Install required plugins

4. **Development Workflow:**

- Create new templates in resources/views
- Add styles in resources/styles
- Add JavaScript in resources/scripts
- Use Blade templating for PHP
- Use Tailwind CSS (if configured) for styling
- Use Alpine.js (if configured) for interactivity

5. **Building for Production:**

- Run npm run build to create production assets
- This will:
  - Minify CSS/JS
  - Optimize images
  - Generate production-ready assets

6. **Version Control:**

- Commit your changes
- Push to your repository
- CI pipeline will run tests and linting
- Requirements
  - ci.yml will run on commits to remote repos
  - commits must be signed
  - .gitignore must be present and well-formed
  - PHP linting (via pint --test) must succeed
  - PHP Unit Tests - if any - must succeed

7. **Deployment:**

- Deploy to your staging/production environment
- Run `make deploy`
- Make sure to set proper environment variables

## Key directories to work with:

- web/app/themes/your-theme-name/resources/ - Your source files
- web/app/themes/your-theme-name/public/ - Compiled assets
- web/app/themes/your-theme-name/resources/views/ - Blade templates
- web/app/themes/your-theme-name/resources/functions.php - Theme functions
