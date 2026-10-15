# cloud-portofolio

My resume as a website. Plain HTML/CSS/JS, no build step, no backend.
Hosted on a private S3 bucket served by CloudFront (OAC). Infra lives in [infra-foundry](https://github.com/elyas-gitspace/infra-foundry).

```
site/
├── index.html          # the whole portfolio
├── 404.html
├── favicon.svg
├── robots.txt
└── assets/
    ├── css/style.css
    ├── js/main.js       # optional enhancements (menu, scroll reveal)
    └── fonts/           # self-hosted Fraunces + Instrument Sans (OFL)
deploy.sh               # sync to S3 + CloudFront invalidation
```

## Run locally

```bash
cd site && python3 -m http.server 8000
```

## Deploy

```bash
BUCKET=<bucket> DISTRIBUTION_ID=<id> ./deploy.sh
```

## CloudFront settings expected

- `default_root_object = "index.html"`
- Custom error response: 403 and 404 → `/404.html` (code 404). With OAC, a missing object returns 403.
- Viewer protocol policy: redirect-to-https, compression enabled.

## When a domain is added

Add `<link rel="canonical">`, `og:url` and a `sitemap.xml` pointing to it (SEO).
