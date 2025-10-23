---
name: Migrate to Quarkus Roq
about: Track the migration from Awestruct to Quarkus Roq
title: 'Migrate website from Awestruct to Quarkus Roq'
labels: enhancement, migration
assignees: ''
---

## Migration Goal

Migrate this blog from Awestruct (Ruby-based) to Quarkus Roq (Quarkus-based static site generator) to modernize the technology stack while maintaining all existing functionality and content.

⚠️ **CRITICAL REQUIREMENT**: All URLs must remain identical to preserve SEO rankings and avoid broken external links. Current WordPress-compatible URL format (`/YYYY/MM/DD/post-slug/`) must be maintained exactly.

## Documentation

See the detailed migration guide: [MIGRATION_TO_QUARKUS_ROQ.md](../../MIGRATION_TO_QUARKUS_ROQ.md)

## Quick Summary

### Current Stack
- Static Site Generator: Awestruct 0.5.7
- Templates: Slim
- Content: AsciiDoc
- Styling: Bootstrap, Sass, Compass
- Features: Blog posts, pagination, RSS/Atom feed, Disqus comments, Google Analytics

### Target Stack
- Static Site Generator: Quarkus Roq
- Templates: Qute (Quarkus templating)
- Content: AsciiDoc (maintained)
- Styling: Bootstrap, SCSS (maintained)
- Features: All current features plus modern Quarkus capabilities

## Migration Phases

### Phase 1: Setup ⏳
- [ ] Install Java 17+, Maven, Quarkus CLI
- [ ] Create new Quarkus Roq project
- [ ] Understand Roq directory structure

### Phase 2: Configuration ⏳
- [ ] Migrate site.yml to application.properties
- [ ] **Configure URL format to match existing WordPress-compatible structure: `/YYYY/MM/DD/post-slug/`**
- [ ] Configure AsciiDoc settings
- [ ] Set up profiles (dev/production)

### Phase 3: Content ⏳
- [ ] Move blog posts to content/posts/
- [ ] Update frontmatter format
- [ ] **Verify each post URL matches original format exactly**
- [ ] Migrate pages (about, etc.)
- [ ] Handle archives

### Phase 4: Templates ⏳
- [ ] Convert base.html.slim to Qute main.html
- [ ] Convert post.html.slim to Qute post.html
- [ ] Migrate index and pagination
- [ ] Convert partials

### Phase 5: Styling ⏳
- [ ] Move CSS/SCSS to static directory
- [ ] Configure SCSS compilation
- [ ] Integrate Bootstrap
- [ ] Configure syntax highlighting

### Phase 6: Assets ⏳
- [ ] Move images to static/images/
- [ ] Copy favicon and CNAME
- [ ] Update asset references

### Phase 7: Features ⏳
- [ ] Configure RSS/Atom feed
- [ ] Implement pagination (5 posts/page)
- [ ] Set up Disqus integration
- [ ] Add Google Analytics
- [ ] Integrate Twitter timeline

### Phase 8: Build & Dev ⏳
- [ ] Configure development mode
- [ ] Set up build process
- [ ] Test live reload

### Phase 9: Deployment ⏳
- [ ] Configure GitHub Pages deployment
- [ ] Set up GitHub Actions (optional)
- [ ] Configure custom domain (www.next-presso.com)

### Phase 10: Testing ⏳
- [ ] **Verify all URLs match original site exactly (CRITICAL)**
- [ ] Verify all posts render correctly
- [ ] Test responsive design
- [ ] Validate RSS feed
- [ ] Cross-browser testing
- [ ] Performance audit
- [ ] SEO validation and URL comparison

### Phase 11: Cutover ⏳
- [ ] Backup current site
- [ ] Deploy new site
- [ ] Monitor for issues
- [ ] Verify analytics

### Phase 12: Cleanup ⏳
- [ ] Remove old Ruby files
- [ ] Update documentation
- [ ] Clean up Git repository

## Estimated Timeline

**Total Time**: 2-3 weeks

- Setup & Config: 1-2 days
- Content & Templates: 5-8 days  
- Styling & Assets: 3 days
- Features & Testing: 5-6 days
- Deployment & Cleanup: 2-3 days

## Success Criteria

- ✅ **All URLs identical to original site (CRITICAL for SEO)**
- ✅ All blog posts accessible and properly formatted
- ✅ Responsive design works on all devices
- ✅ RSS feed functional
- ✅ Comments working (Disqus)
- ✅ Analytics tracking
- ✅ No broken links
- ✅ Performance maintained or improved
- ✅ Successful GitHub Pages deployment

## Resources

- [Quarkus Roq Documentation](https://docs.quarkiverse.io/quarkus-roq/dev/index.html)
- [Qute Template Guide](https://quarkus.io/guides/qute-reference)
- [Migration Guide](../../MIGRATION_TO_QUARKUS_ROQ.md)

## Questions

- [ ] Target Quarkus Roq version?
- [ ] **Confirm Quarkus Roq can maintain WordPress-compatible URL format: `/YYYY/MM/DD/post-slug/`**
- [ ] Upgrade dependencies (Bootstrap, Font Awesome)?
- [ ] Add new features during migration?
- [ ] Acceptable downtime window?

## Notes

- Preserve Git history
- Test on migration branch first
- Keep Awestruct setup in backup branch
- Document all customizations
