# Migration from Awestruct to Quarkus Roq

## Overview

This document outlines the complete migration plan to move this blog from Awestruct (Ruby-based static site generator) to Quarkus Roq (Quarkus-based static site generator).

## Current Stack Analysis

### Technology Stack
- **Static Site Generator**: Awestruct 0.5.7
- **Template Engine**: Slim
- **Content Format**: AsciiDoc
- **Styling**: Bootstrap, Sass, Compass
- **Build Tool**: Ruby Bundler, Rake
- **Dependencies**: 
  - asciidoctor-diagram
  - htmlcompressor
  - uglifier
- **Features**:
  - Blog posts with pagination (5 posts per page)
  - RSS/Atom feed
  - Disqus comments
  - Google Analytics
  - Twitter timeline widget
  - Tags/categorization

### Current Structure
```
.
├── _config/              # Site configuration
│   ├── site.yml         # Main config (base_url, profiles, asciidoctor settings)
│   └── identities.yml   # Author/identity information
├── _ext/                # Awestruct extensions
│   └── pipeline.rb      # Extension pipeline configuration
├── _layouts/            # Page templates
│   ├── base.html.slim   # Base layout
│   └── post.html.slim   # Post layout
├── _partials/           # Reusable components
│   ├── about.adoc
│   ├── post.html.slim
│   └── subscribe.html.slim
├── _archives/           # Archived posts
├── stylesheets/         # CSS/SCSS files
├── images/              # Static images
├── *.adoc               # Blog posts (root level)
├── index.html.slim      # Homepage with post list
├── about.html.slim      # About page
├── Gemfile              # Ruby dependencies
└── Rakefile             # Build tasks
```

## Critical Requirement: URL Preservation for SEO

⚠️ **IMPORTANT**: All existing URLs must remain identical after migration to preserve SEO rankings and avoid broken links.

The current Awestruct setup uses WordPress-compatible URLs (`:wp_compat=>true`), which generates URLs in the format:
- Blog posts: `/YYYY/MM/DD/post-slug/` (e.g., `/2014/03/15/forward-cdi-2-0/`)
- Pagination: `/page/N/` (e.g., `/page/2/`)
- RSS feed: `/news.atom`
- Homepage: `/`

**During migration, you MUST:**
- [ ] Configure Quarkus Roq to generate identical URL patterns
- [ ] Verify all blog post URLs match the original structure exactly
- [ ] Ensure pagination URLs remain unchanged
- [ ] Maintain the same feed URL (`/news.atom`)
- [ ] Test all existing URLs before going live
- [ ] Set up 301 redirects only if absolutely necessary (prefer exact URL matching)
- [ ] Verify URL structure in Google Search Console after migration

**Why this matters:**
- Existing URLs are indexed by search engines
- External sites link to current URLs
- Changing URLs will break incoming links and hurt SEO rankings
- Users may have bookmarked specific posts

## Migration Steps

### Phase 1: Project Setup

#### 1.1 Install Prerequisites
- [ ] Install Java 17 or later (required for Quarkus)
- [ ] Install Maven 3.9+ or Gradle
- [ ] Install Quarkus CLI (optional but recommended)
  ```bash
  curl -Ls https://sh.jbang.dev | bash -s - trust add https://repo1.maven.org/maven2/io/quarkus/quarkus-cli/
  curl -Ls https://sh.jbang.dev | bash -s - app install --fresh --force quarkus@quarkusio
  ```

#### 1.2 Create New Quarkus Roq Project
- [ ] Create a new Quarkus Roq project
  ```bash
  quarkus create app com.next-presso:blog \
    --extension=io.quarkiverse.roq:quarkus-roq \
    --no-code
  ```
- [ ] Or use Maven:
  ```bash
  mvn io.quarkus:quarkus-maven-plugin:3.15.0:create \
    -DprojectGroupId=com.next-presso \
    -DprojectArtifactId=blog \
    -Dextensions=io.quarkiverse.roq:quarkus-roq
  ```

#### 1.3 Project Structure Understanding
- [ ] Understand Roq directory structure:
  ```
  src/main/
  ├── java/              # Optional Java code
  ├── resources/
  │   ├── templates/     # Qute templates (equivalent to _layouts)
  │   │   ├── main.html  # Base layout
  │   │   └── post.html  # Post layout
  │   ├── content/       # Blog posts and pages
  │   │   └── posts/     # Blog posts directory
  │   └── static/        # Static assets (CSS, JS, images)
  │       ├── css/
  │       ├── js/
  │       └── images/
  └── application.properties  # Roq configuration
  ```

### Phase 2: Configuration Migration

#### 2.1 Site Configuration
- [ ] Migrate settings from `_config/site.yml` to `application.properties`:
  ```properties
  # Basic site info
  roq.site.title=Next Presso
  roq.site.description=CDI, Java EE and friends
  
  # URLs
  quarkus.roq.site.url=http://localhost:8080
  %prod.quarkus.roq.site.url=https://www.next-presso.com
  
  # Blog configuration
  roq.blog.posts-per-page=5
  
  # CRITICAL: URL Structure Configuration (MUST match existing URLs for SEO)
  # Current Awestruct uses WordPress-compatible URLs: /YYYY/MM/DD/post-slug/
  # Configure Roq to generate identical URL patterns
  quarkus.roq.url-format=/YYYY/MM/DD/post-slug/
  # Note: Verify exact configuration option with Quarkus Roq documentation
  
  # Google Analytics
  roq.site.google-analytics-id=UA-5919317-1
  
  # Disqus
  roq.site.disqus-shortname=nextpresso
  ```

#### 2.2 Author/Identity Configuration
- [ ] Create author information in frontmatter or configuration
- [ ] Migrate from `_config/identities.yml`

#### 2.3 AsciiDoc Configuration
- [ ] Configure AsciiDoc settings:
  ```properties
  quarkus.roq.asciidoc.safe-mode=unsafe
  quarkus.roq.asciidoc.attributes.icons=font
  quarkus.roq.asciidoc.attributes.source-highlighter=highlight.js
  quarkus.roq.asciidoc.attributes.source-language=java
  quarkus.roq.asciidoc.attributes.sectanchors=true
  quarkus.roq.asciidoc.attributes.linkattrs=true
  ```

### Phase 3: Content Migration

#### 3.1 Blog Posts Migration
- [ ] Move all `.adoc` files to `src/main/resources/content/posts/`
- [ ] Update frontmatter format from Awestruct to Roq:
  
  **Before (Awestruct)**:
  ```yaml
  ---
  title: Post Title
  author: Antoine Sabot-Durand
  layout: post
  tags: [cdi, java]
  ---
  ```
  
  **After (Roq)**:
  ```yaml
  ---
  layout: :post
  title: Post Title
  date: 2024-01-01
  tags: 
    - cdi
    - java
  authors: 
    - Antoine Sabot-Durand
  ---
  ```

- [ ] Ensure post filenames follow Roq convention: `YYYY-MM-DD-slug.adoc`
- [ ] **CRITICAL**: Verify each post's URL matches the original Awestruct URL exactly
  - Current format: `/YYYY/MM/DD/post-slug/`
  - Example: `2014-03-15-forward-cdi-2-0.adoc` → `/2014/03/15/forward-cdi-2-0/`
  - Test each URL individually to ensure no changes
- [ ] Review and update image paths (from relative to `/images/` or appropriate paths)
- [ ] Test all internal links and anchors

#### 3.2 Pages Migration
- [ ] Create `src/main/resources/content/about.adoc` from `about.html.slim`
- [ ] Convert Slim content to AsciiDoc or HTML as needed
- [ ] Migrate partials from `_partials/` to appropriate locations

#### 3.3 Archives
- [ ] Decide on archived posts handling
- [ ] Move archived content from `_archives/` if needed

### Phase 4: Template Migration

#### 4.1 Understand Qute Syntax
- [ ] Learn Qute template syntax (Quarkus templating engine)
- [ ] Key differences from Slim:
  - Qute uses `{variable}` instead of `= variable`
  - Loops: `{#for post in posts}...{/for}`
  - Conditionals: `{#if condition}...{/if}`
  - Includes: `{#include template /}`

#### 4.2 Base Layout Migration
- [ ] Create `src/main/resources/templates/main.html`
- [ ] Convert `_layouts/base.html.slim` to Qute HTML
- [ ] Migrate navigation structure
- [ ] Migrate header/footer
- [ ] Update CSS/JS includes

**Example Base Template Structure**:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title ?: site.title}</title>
    <link rel="stylesheet" href="/static/css/styles.css">
    {#if site.googleAnalyticsId}
    <!-- Google Analytics -->
    {/if}
</head>
<body>
    {#insert header /}
    <main>
        {#insert body /}
    </main>
    {#insert footer /}
</body>
</html>
```

#### 4.3 Post Layout Migration
- [ ] Create `src/main/resources/templates/post.html`
- [ ] Convert `_layouts/post.html.slim` to Qute
- [ ] Implement post metadata display (date, author, tags)
- [ ] Migrate Disqus integration
- [ ] Migrate Twitter timeline widget
- [ ] Implement social sharing buttons if present

#### 4.4 Index/Homepage Migration
- [ ] Create blog index template
- [ ] Convert `index.html.slim` pagination logic to Qute
- [ ] Implement post excerpts
- [ ] Create pagination controls (Previous/Next, page numbers)

#### 4.5 Partial Templates
- [ ] Create reusable components in `templates/` or `templates/fragments/`
- [ ] Convert `_partials/post.html.slim` → post fragment
- [ ] Convert `_partials/subscribe.html.slim` → subscription fragment
- [ ] Convert `_partials/about.adoc` as needed

### Phase 5: Styling Migration

#### 5.1 CSS/SCSS Migration
- [ ] Move `stylesheets/` content to `src/main/resources/static/css/`
- [ ] Setup SCSS compilation if needed (or convert to plain CSS)
  - Option 1: Use frontend-maven-plugin with node-sass
  - Option 2: Pre-compile SCSS to CSS
  - Option 3: Use Quarkus extensions for SCSS
- [ ] Migrate `styles.scss`
- [ ] Migrate `asciidoctor.css` for AsciiDoc styling
- [ ] Migrate `_asciidoctor-coderay.scss`

#### 5.2 Bootstrap Integration
- [ ] Add Bootstrap CSS
  - Option 1: CDN link in main template
  - Option 2: NPM + build process
  - Option 3: Copy Bootstrap files to static directory
- [ ] Ensure Bootstrap JavaScript is loaded
- [ ] Test responsive behavior

#### 5.3 Font Awesome
- [ ] Add Font Awesome (currently using 4.3.0)
- [ ] Consider upgrading to Font Awesome 6.x
- [ ] Update icon classes if upgraded

#### 5.4 Syntax Highlighting
- [ ] Configure highlight.js or alternative
- [ ] Current: highlight.js 9.9.0 with GitHub theme
- [ ] Consider using Quarkus Roq's built-in syntax highlighting
- [ ] Ensure Java code highlighting works properly

### Phase 6: Static Assets Migration

#### 6.1 Images
- [ ] Copy `images/` directory to `src/main/resources/static/images/`
- [ ] Update image references in templates
- [ ] Update image references in blog posts
- [ ] Verify all images load correctly

#### 6.2 Other Assets
- [ ] Move any JavaScript files to `src/main/resources/static/js/`
- [ ] Move favicon.ico to static root
- [ ] Copy CNAME file for GitHub Pages custom domain

### Phase 7: Features Implementation

#### 7.1 RSS/Atom Feed
- [ ] Configure Roq RSS feed
- [ ] Current: `/news.atom` with 20 entries
- [ ] Verify feed validates and works with readers
- [ ] Update feed URL references

#### 7.2 Pagination
- [ ] Implement pagination (5 posts per page)
- [ ] Create pagination controls
- [ ] Test pagination navigation
- [ ] **CRITICAL**: Ensure pagination URLs match existing format exactly: `/page/2/`, `/page/3/`, etc.
- [ ] Verify the homepage is at `/` (not `/page/1/`)

#### 7.3 Tags/Categories
- [ ] Implement tag pages if present
- [ ] Create tag cloud if needed
- [ ] Link posts to tag archives

#### 7.4 Disqus Comments
- [ ] Integrate Disqus in post template
- [ ] Configure Disqus shortname: `nextpresso`
- [ ] Test comment threading
- [ ] Verify comment counts display

#### 7.5 Google Analytics
- [ ] Add Google Analytics tracking code
- [ ] Account: UA-5919317-1
- [ ] Consider upgrading to GA4
- [ ] Test tracking in production

#### 7.6 Social Media Integration
- [ ] Migrate Twitter timeline widget
- [ ] Widget ID: 666631820319019009
- [ ] Handle: @antoine_sd
- [ ] Ensure responsive display (hidden-xs, visible-xs)

#### 7.7 Search Functionality
- [ ] Consider adding search (not in current site)
- [ ] Options: Lunr.js, Pagefind, or server-side search

### Phase 8: Build and Development Workflow

#### 8.1 Development Mode
- [ ] Run Quarkus in dev mode:
  ```bash
  quarkus dev
  # or
  mvn quarkus:dev
  ```
- [ ] Configure live reload for templates and content
- [ ] Verify hot reload works for content changes

#### 8.2 Build Process
- [ ] Build static site:
  ```bash
  quarkus build
  # or
  mvn clean package
  ```
- [ ] Configure production build settings
- [ ] Optimize for production (minification, compression)

#### 8.3 Preview
- [ ] Test local preview on http://localhost:8080
- [ ] Verify all pages render correctly
- [ ] Test navigation and links
- [ ] Check responsive design on different screen sizes

### Phase 9: Deployment

#### 9.1 GitHub Pages Configuration
- [ ] Configure static site generation output directory
- [ ] Current deployment: GitHub Pages, master branch
- [ ] Generate static output:
  ```bash
  quarkus build -Dquarkus.roq.site.url=https://www.next-presso.com
  ```
- [ ] Output directory: `target/roq/`

#### 9.2 Deployment Strategy Options

**Option A: Manual Deployment**
- [ ] Build static site locally
- [ ] Copy output to GitHub Pages branch
- [ ] Push to repository

**Option B: GitHub Actions**
- [ ] Create `.github/workflows/deploy.yml`
- [ ] Automate build and deployment
- [ ] Example workflow:
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

**Option C: Quarkus Roq GitHub Pages Extension**
- [ ] Use built-in GitHub Pages deployment if available
- [ ] Configure in `application.properties`

#### 9.3 CNAME
- [ ] Ensure CNAME file is in output
- [ ] Content: `www.next-presso.com`
- [ ] Verify custom domain works after deployment

### Phase 10: Testing and Validation

#### 10.1 Content Verification
- [ ] **CRITICAL**: Verify all blog post URLs are identical to the original site
  - Create a list of all URLs from the current site
  - Compare against URLs generated by Quarkus Roq
  - Ensure 100% URL match (no changes allowed)
- [ ] Verify all blog posts render correctly
- [ ] Check AsciiDoc formatting
- [ ] Validate code blocks and syntax highlighting
- [ ] Test images and embedded content
- [ ] Verify internal links work
- [ ] Check external links (optional: use link checker)

#### 10.2 Functional Testing
- [ ] Test homepage and pagination
- [ ] Test individual post pages
- [ ] Test about page
- [ ] Verify RSS/Atom feed
- [ ] Test Disqus comments
- [ ] Verify Google Analytics tracking
- [ ] Test Twitter widget

#### 10.3 Cross-Browser Testing
- [ ] Test in Chrome
- [ ] Test in Firefox
- [ ] Test in Safari
- [ ] Test in Edge
- [ ] Test mobile browsers

#### 10.4 Responsive Design
- [ ] Test on mobile devices (iOS, Android)
- [ ] Test on tablets
- [ ] Verify hidden-xs/visible-xs classes work
- [ ] Check navigation on small screens

#### 10.5 Performance
- [ ] Run Lighthouse audit
- [ ] Check page load times
- [ ] Optimize images if needed
- [ ] Verify CSS/JS minification
- [ ] Test caching headers

#### 10.6 SEO Validation
- [ ] **CRITICAL**: Verify all URLs match the original site exactly
  - Test a sample of blog post URLs from each year
  - Verify pagination URLs (`/page/2/`, `/page/3/`, etc.)
  - Check RSS feed URL (`/news.atom`)
  - Ensure homepage is at `/`
- [ ] Create a URL comparison checklist: old site vs new site
- [ ] Verify meta tags (title, description)
- [ ] Check OpenGraph tags
- [ ] Validate Twitter Card markup
- [ ] Test structured data
- [ ] Verify sitemap.xml generation (ensure URLs match original)
- [ ] Check robots.txt
- [ ] Run a broken link checker on the new site
- [ ] Verify in Google Search Console after migration

### Phase 11: Migration Cutover

#### 11.1 Pre-Migration
- [ ] Backup current site
- [ ] Document current analytics/metrics
- [ ] **Export complete list of all current URLs for comparison**
- [ ] Set up URL monitoring/comparison tool
- [ ] Prepare rollback plan

#### 11.2 Migration
- [ ] Deploy new Quarkus Roq site
- [ ] Update DNS if needed
- [ ] Monitor for issues

#### 11.3 Post-Migration
- [ ] Verify site is live and working
- [ ] Check analytics are tracking
- [ ] Monitor for 404 errors
- [ ] Fix any broken links
- [ ] Update any external references to site

### Phase 12: Cleanup

#### 12.1 Remove Old Files
- [ ] Remove Gemfile and Gemfile.lock
- [ ] Remove Rakefile
- [ ] Remove `_ext/` directory
- [ ] Remove `.awestruct_ignore`
- [ ] Remove old `.adoc` files from root (after copying to new location)
- [ ] Clean up any Ruby-specific files

#### 12.2 Update Documentation
- [ ] Create new README.md with Quarkus Roq instructions
- [ ] Document build process
- [ ] Document deployment process
- [ ] Update contribution guidelines if any

#### 12.3 Git Cleanup
- [ ] Consider creating a migration branch
- [ ] Tag the old Awestruct version
- [ ] Update .gitignore for Maven/Quarkus:
  ```
  target/
  .idea/
  *.iml
  .settings/
  .project
  .classpath
  ```

## Resources and References

### Quarkus Roq Documentation
- [ ] [Quarkus Roq Guide](https://docs.quarkiverse.io/quarkus-roq/dev/index.html)
- [ ] [Qute Template Engine](https://quarkus.io/guides/qute-reference)
- [ ] [Quarkus Website](https://quarkus.io)

### Migration Tools
- [ ] [HTML to Qute Converter](https://html2qute.github.io/) - if available
- [ ] Slim to HTML converter
- [ ] SCSS compiler

### Community Support
- [ ] Quarkus Roq GitHub Issues
- [ ] Quarkus Zulip Chat
- [ ] Stack Overflow `quarkus-roq` tag

## Estimated Timeline

- **Phase 1-2 (Setup & Config)**: 1-2 days
- **Phase 3 (Content Migration)**: 2-3 days
- **Phase 4 (Templates)**: 3-5 days
- **Phase 5 (Styling)**: 2-3 days
- **Phase 6 (Assets)**: 1 day
- **Phase 7 (Features)**: 2-3 days
- **Phase 8 (Build/Dev)**: 1 day
- **Phase 9 (Deployment)**: 1-2 days
- **Phase 10 (Testing)**: 2-3 days
- **Phase 11 (Cutover)**: 1 day
- **Phase 12 (Cleanup)**: 1 day

**Total Estimated Time**: 2-3 weeks

## Success Criteria

- [ ] **All URLs are identical to the original site (CRITICAL)**
- [ ] All blog posts accessible and properly formatted
- [ ] Responsive design works on all devices
- [ ] RSS feed functional at `/news.atom`
- [ ] Comments working (Disqus)
- [ ] Analytics tracking
- [ ] All images and assets load correctly
- [ ] No broken links
- [ ] Performance equal or better than current site
- [ ] SEO maintained (verified via Google Search Console)
- [ ] No 404 errors from previously working URLs
- [ ] Successful deployment to GitHub Pages

## Risks and Mitigation

### Risk 1: Template Complexity
- **Risk**: Slim to Qute conversion may be complex
- **Mitigation**: Start with simple templates, convert incrementally, keep backup

### Risk 2: AsciiDoc Rendering Differences
- **Risk**: AsciiDoc may render differently in Roq
- **Mitigation**: Test thoroughly, adjust AsciiDoc settings, maintain output consistency

### Risk 3: Deployment Issues
- **Risk**: GitHub Pages deployment may differ
- **Mitigation**: Test deployment to staging branch first, prepare rollback

### Risk 4: Loss of SEO/Traffic
- **Risk**: URL structure changes could impact SEO rankings and break external links
- **Severity**: CRITICAL - This is the highest priority to avoid
- **Mitigation**: 
  - **MAINTAIN IDENTICAL URL STRUCTURE** - URLs must not change
  - Current WordPress-compatible format: `/YYYY/MM/DD/post-slug/`
  - Configure Quarkus Roq to generate exact same URL patterns
  - Create comprehensive URL comparison checklist before migration
  - Test every single URL to ensure exact match
  - Only use 301 redirects as absolute last resort (prefer exact matching)
  - Verify in Google Search Console after migration
  - Monitor analytics for any traffic drops
  - Keep original site accessible during validation period

### Risk 5: Feature Parity
- **Risk**: Some Awestruct features may not have direct equivalents
- **Mitigation**: Identify critical features early, find alternatives or implement custom solutions

## Notes

- Preserve all Git history during migration
- Consider creating a `migration` branch for testing
- Keep the old Awestruct setup in a separate branch for reference
- Document any customizations or workarounds for future reference
- Test thoroughly before switching production

## Benefits of Migration

1. **Modern Technology**: Move from Ruby/Awestruct to Java/Quarkus
2. **Active Development**: Quarkus is actively maintained
3. **Performance**: Potential performance improvements
4. **Developer Experience**: Hot reload, better tooling
5. **Ecosystem**: Access to Java/Quarkus ecosystem
6. **Cloud Native**: Built for cloud-native deployments
7. **Type Safety**: Better type safety with Qute templates
8. **Maintainability**: Easier to maintain with Java tooling

## Questions to Answer Before Starting

- [ ] Is there a specific Quarkus Roq version to target?
- [ ] Are there any custom Awestruct extensions that need equivalent functionality?
- [ ] **URL structure MUST remain identical - confirm Quarkus Roq can generate `/YYYY/MM/DD/slug/` format**
- [ ] Are there any performance requirements or benchmarks?
- [ ] Should we upgrade any dependencies (Bootstrap, Font Awesome, etc.)?
- [ ] Do we want to add any new features during migration?
- [ ] What is the acceptable downtime for migration?
