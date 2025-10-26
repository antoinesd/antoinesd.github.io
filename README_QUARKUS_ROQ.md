# Next Presso Blog - Quarkus Roq Migration

This blog has been migrated from Awestruct (Ruby-based) to Quarkus Roq (Quarkus-based static site generator).

## Prerequisites

- Java 17 or later
- Maven 3.9+

## Project Structure

```
.
├── pom.xml                          # Maven build configuration
├── src/
│   └── main/
│       └── resources/
│           ├── application.properties    # Roq configuration
│           ├── content/                  # Blog content
│           │   ├── posts/               # Blog posts (AsciiDoc)
│           │   └── about.adoc           # About page
│           ├── templates/               # Qute templates
│           │   ├── main.html           # Base layout
│           │   ├── post.html           # Post layout
│           │   ├── page.html           # Page layout
│           │   └── index.html          # Homepage/pagination
│           └── static/                  # Static assets
│               ├── css/                # Stylesheets
│               ├── images/             # Images
│               └── CNAME              # Custom domain config
```

## Building the Site

### Development Mode

```bash
mvn quarkus:dev
```

The site will be available at `http://localhost:8080`

### Production Build

```bash
mvn clean package
```

The static site will be generated in `target/roq/`

## Deployment to GitHub Pages

The generated static site in `target/roq/` can be deployed to GitHub Pages.

### Manual Deployment

1. Build the site:
   ```bash
   mvn clean package -Dquarkus.roq.site.url=https://www.next-presso.com
   ```

2. Copy the contents of `target/roq/` to your GitHub Pages branch

3. Commit and push

### GitHub Actions (Recommended)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Build with Maven
        run: mvn clean package -Dquarkus.roq.site.url=https://www.next-presso.com
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./target/roq
          cname: www.next-presso.com
```

## Configuration

Key configuration is in `src/main/resources/application.properties`:

```properties
# Site Information
quarkus.roq.site.title=Next Presso
quarkus.roq.site.description=CDI, Java EE and friends

# URLs (CRITICAL for SEO - must match existing structure)
quarkus.roq.site.url=http://localhost:8080
%prod.quarkus.roq.site.url=https://www.next-presso.com

# Blog Settings
quarkus.roq.blog.posts-per-page=5

# Features
quarkus.roq.site.google-analytics-id=UA-5919317-1
quarkus.roq.site.disqus-shortname=nextpresso
quarkus.roq.site.twitter-widget-id=666631820319019009
quarkus.roq.site.twitter-handle=@antoine_sd

# RSS Feed
quarkus.roq.feed.path=/news.atom
quarkus.roq.feed.entries=20
```

## Content Format

Blog posts are in AsciiDoc format with YAML frontmatter:

```yaml
---
layout: :post
title: "Post Title"
summary: Brief description of the post
date: 2024-03-15
authors:
  - Antoine Sabot-Durand
tags:
  - CDI
  - Java
---

= Post Title

Content here...
```

## URL Structure

⚠️ **CRITICAL for SEO**: URLs must remain identical to the original Awestruct site:

- Blog posts: `/YYYY/MM/DD/post-slug/`
- Pagination: `/page/N/`
- RSS feed: `/news.atom`
- Homepage: `/`

## Migration Details

### Completed

- ✅ Project setup with Maven and Quarkus Roq
- ✅ Configuration migration from `site.yml` to `application.properties`
- ✅ Content migration (7 blog posts) with updated frontmatter
- ✅ Template conversion from Slim to Qute
- ✅ Static assets (CSS, images, CNAME, favicon)
- ✅ Feature integration (Disqus, Google Analytics, Twitter timeline)

### Pending/To Verify

- ⏳ URL format verification (ensure exact match with Awestruct URLs)
- ⏳ Build configuration refinement
- ⏳ RSS feed generation verification
- ⏳ Pagination URL testing
- ⏳ Cross-browser testing
- ⏳ SEO validation

## Technology Stack

- **Static Site Generator**: Quarkus Roq 1.3.3
- **Java Runtime**: OpenJDK 17
- **Build Tool**: Maven 3.9+
- **Template Engine**: Qute (Quarkus templating)
- **Content Format**: AsciiDoc
- **Styling**: Bootstrap, SCSS

## Old Stack (Awestruct)

The original Awestruct files are preserved in the repository:

- `Gemfile`, `Gemfile.lock` - Ruby dependencies
- `Rakefile` - Build tasks
- `_config/` - Awestruct configuration
- `_ext/` - Awestruct extensions
- `_layouts/` - Slim templates
- `_partials/` - Reusable Slim components

These files can be removed once the migration is fully validated.

## Troubleshooting

### Build Fails

If you encounter build errors, try:

1. Clean Maven cache: `mvn clean`
2. Update dependencies: `mvn dependency:resolve`
3. Check Java version: `java -version` (should be 17+)

### URLs Don't Match

Verify the URL configuration in `application.properties` and check Roq documentation for permalink configuration.

### Static Assets Not Loading

Ensure static assets are in `src/main/resources/static/` and references use `/static/` prefix.

## Resources

- [Quarkus Roq Documentation](https://docs.quarkiverse.io/quarkus-roq/dev/index.html)
- [Qute Template Guide](https://quarkus.io/guides/qute-reference)
- [Migration Guide](MIGRATION_TO_QUARKUS_ROQ.md)

## License

Content and code are the property of Antoine Sabot-Durand. Opinions expressed are personal and not those of Red Hat.
