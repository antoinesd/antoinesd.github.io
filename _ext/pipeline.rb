require 'bootstrap-sass'
require 'compass'
require 'slim'
require 'asciidoctor-diagram'

Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::DataDir.new
  extension Awestruct::Extensions::Posts.new('', :posts, nil, nil, :wp_compat=>true )
  extension Awestruct::Extensions::Paginator.new( :posts, '/index', :per_page=>5 )
  extension Awestruct::Extensions::Atomizer.new( :posts, '/news.atom', :num_entries=>20 )


  # extension Awestruct::Extensions::Atomizer.new( :news, '/news/feed.atom' )

  # It would be really cool to combine these, will need to look into it.
  # extension Awestruct::Extensions::Tagger.new( :faq, '/faq', '/faq/tags', :per_page=>10)
  # TODO: TagCloud

  # Awestruct::Extensions::Jira::Project.new(self, 'CDI:12311062')

  # todo: asciidoc, as we're on a version of asciidoc that I don't think
  #       has it built in we'll need our own version

  extension Awestruct::Extensions::Disqus.new
  helper Awestruct::Extensions::Partial
  helper Awestruct::Extensions::GoogleAnalytics

  extension Awestruct::Extensions::Indexifier.new
  transformer Awestruct::Extensions::Minify.new
end
