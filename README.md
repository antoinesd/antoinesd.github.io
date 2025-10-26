# Antoine Sabot-Durand's Blog - Next Presso

This is the source code for the Next Presso blog (www.next-presso.com), covering topics on CDI, Java EE, and related technologies.

## Current Technology Stack

This site is currently built with:

- **Static Site Generator**: [Awestruct](http://awestruct.org/) 0.5.7
- **Template Engine**: [Slim](http://slim-lang.com/)
- **Content Format**: [AsciiDoc](https://asciidoc.org/)
- **Styling**: Bootstrap, Sass, Compass
- **Build Tool**: Ruby Bundler, Rake
- **Hosting**: GitHub Pages

## Development Setup

### Prerequisites

- Ruby 2.x or later
- Bundler gem

### Installation

1. Install dependencies:
   ```bash
   bundle install
   # or for local installation:
   bundle install --path .bundle
   ```

2. Preview the site locally:
   ```bash
   rake preview
   # or
   rake
   ```
   
   The site will be available at http://localhost:4242

### Building

Generate the static site:
```bash
rake gen
# or for production:
rake gen[production]
```

### Deployment

Deploy to GitHub Pages:
```bash
rake deploy
```

## Project Structure

```
.
├── _config/              # Site configuration
├── _ext/                 # Awestruct extensions
├── _layouts/             # Page templates (Slim)
├── _partials/            # Reusable components
├── _archives/            # Archived posts
├── stylesheets/          # CSS/SCSS files
├── images/               # Static images
├── *.adoc                # Blog posts (AsciiDoc format)
├── Gemfile               # Ruby dependencies
└── Rakefile              # Build tasks
```

## Writing a New Post

1. Create a new `.adoc` file in the root directory with the format:
   ```
   YYYY-MM-DD-title-slug.adoc
   ```

2. Add frontmatter:
   ```yaml
   ---
   title: Your Post Title
   author: Antoine Sabot-Durand
   layout: post
   tags: [cdi, java]
   ---
   ```

3. Write your content in AsciiDoc format

4. Preview locally with `rake preview`

5. Publish with `rake deploy`

## Migration to Quarkus Roq

🚀 **We are planning to migrate this site to Quarkus Roq!**

See the comprehensive migration guide: [MIGRATION_TO_QUARKUS_ROQ.md](MIGRATION_TO_QUARKUS_ROQ.md)

### Why Migrate?

- **Modern Technology**: Move from Ruby/Awestruct to Java/Quarkus
- **Active Development**: Quarkus is actively maintained
- **Performance**: Potential performance improvements
- **Developer Experience**: Hot reload, better tooling
- **Cloud Native**: Built for modern cloud deployments

### Migration Status

Track the migration progress in the [migration issue](.github/ISSUE_TEMPLATE/migration-issue.md).

## Features

- ✅ Blog posts with AsciiDoc
- ✅ Pagination (5 posts per page)
- ✅ RSS/Atom feed
- ✅ Disqus comments
- ✅ Google Analytics
- ✅ Responsive design with Bootstrap
- ✅ Syntax highlighting for code
- ✅ Twitter timeline integration

## License

Content is Copyright © Antoine Sabot-Durand

## Author

**Antoine Sabot-Durand**
- Twitter: [@antoine_sd](https://twitter.com/antoine_sd)
- Website: [www.next-presso.com](https://www.next-presso.com/)

---

*Last updated: 2024 - Awestruct version*
