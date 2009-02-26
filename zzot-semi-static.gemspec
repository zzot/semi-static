# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{zzot-semi-static}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Dady"]
  s.date = %q{2009-02-25}
  s.default_executable = %q{semi}
  s.description = %q{Semi-Static is yet another static site generator.}
  s.email = %q{projects@zzot.net}
  s.executables = ["semi"]
  s.files = ["History.txt", "Manifest.txt", "README.markdown", "VERSION.yml", "bin/semi", "lib/semi-static", "lib/semi-static/base.rb", "lib/semi-static/categories.rb", "lib/semi-static/cli.rb", "lib/semi-static/convertable.rb", "lib/semi-static/core_ext", "lib/semi-static/core_ext/hash.rb", "lib/semi-static/index.rb", "lib/semi-static/layout.rb", "lib/semi-static/page.rb", "lib/semi-static/post.rb", "lib/semi-static/posts.rb", "lib/semi-static/pygmentize.rb", "lib/semi-static/site.rb", "lib/semi-static/snippet.rb", "lib/semi-static/statistics.rb", "lib/semi-static/stylesheet.rb", "lib/semi-static.rb", "test/helper.rb", "test/output", "test/output/2005", "test/output/2005/03", "test/output/2005/03/27", "test/output/2005/03/27/a-bash-script-to-mess-with-the-containing-terminalapp-window.html", "test/output/2005/03/27/index.html", "test/output/2005/03/index.html", "test/output/2005/index.html", "test/output/2008", "test/output/2008/11", "test/output/2008/11/24", "test/output/2008/11/24/index.html", "test/output/2008/11/24/lighting-up.html", "test/output/2008/11/26", "test/output/2008/11/26/impressions.html", "test/output/2008/11/26/index.html", "test/output/2008/11/index.html", "test/output/2008/12", "test/output/2008/12/04", "test/output/2008/12/04/index.html", "test/output/2008/12/04/the-working-mans-typeface.html", "test/output/2008/12/index.html", "test/output/2008/index.html", "test/output/about.html", "test/output/colophon.html", "test/output/css", "test/output/css/screen.css", "test/output/css/syntax.css", "test/output/feed.xml", "test/output/scripts", "test/output/scripts/jquery-1.3.js", "test/output/scripts/jquery-1.3.min.js", "test/ref", "test/ref/test_layout", "test/ref/test_layout/default_layout.html", "test/ref/test_layout/post_layout.html", "test/ref/test_output", "test/ref/test_output/2005-03-27.html", "test/ref/test_output/2005-03.html", "test/ref/test_output/2005.html", "test/ref/test_output/2008-11-24.html", "test/ref/test_output/2008-11-26.html", "test/ref/test_output/2008-11.html", "test/ref/test_output/2008-12-04.html", "test/ref/test_output/2008-12.html", "test/ref/test_output/2008.html", "test/ref/test_page", "test/ref/test_page/about.html", "test/ref/test_page/colophon.html", "test/ref/test_post", "test/ref/test_post/impressions.html", "test/ref/test_post/lighting-up.html", "test/ref/test_post/the-working-mans-typeface.html", "test/source", "test/source/indices", "test/source/indices/day.erb", "test/source/indices/month.erb", "test/source/indices/year.erb", "test/source/layouts", "test/source/layouts/default.haml", "test/source/layouts/post.erb", "test/source/pages", "test/source/pages/about.md", "test/source/pages/colophon.md", "test/source/pages/feed.xml.erb", "test/source/posts", "test/source/posts/2005-03-27-a-bash-script-to-mess-with-the-containing-terminalapp-window.markdown", "test/source/posts/2008-11-24-lighting-up.markdown", "test/source/posts/2008-11-26-impressions.md", "test/source/posts/2008-12-04-the-working-mans-typeface.html", "test/source/scripts", "test/source/scripts/jquery-1.3.js", "test/source/scripts/jquery-1.3.min.js", "test/source/semi.yml", "test/source/snippets", "test/source/snippets/comment-links.html", "test/source/snippets/comments.html", "test/source/stylesheets", "test/source/stylesheets/layout.sass", "test/source/stylesheets/post.sass", "test/source/stylesheets/screen.sass", "test/source/stylesheets/syntax.css", "test/source/stylesheets/text.sass", "test/test_layout.rb", "test/test_output.rb", "test/test_page.rb", "test/test_post.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/zzot/semi-static}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Semi-Static is yet another static site generator.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<maruku>, [">= 0.5.9"])
      s.add_runtime_dependency(%q<haml>, [">= 2.0.6"])
    else
      s.add_dependency(%q<maruku>, [">= 0.5.9"])
      s.add_dependency(%q<haml>, [">= 2.0.6"])
    end
  else
    s.add_dependency(%q<maruku>, [">= 0.5.9"])
    s.add_dependency(%q<haml>, [">= 2.0.6"])
  end
end
