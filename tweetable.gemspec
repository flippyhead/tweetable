# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tweetable}
  s.version = "0.1.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter T. Brown"]
  s.date = %q{2010-06-21}
  s.description = %q{Track twitter messages and users in memory using Redis}
  s.email = %q{peter@flippyhead.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
     "History.txt",
     "Manifest.txt",
     "PostInstall.txt",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/tweetable.rb",
     "lib/tweetable/authorization.rb",
     "lib/tweetable/collection.rb",
     "lib/tweetable/link.rb",
     "lib/tweetable/message.rb",
     "lib/tweetable/persistable.rb",
     "lib/tweetable/photo.rb",
     "lib/tweetable/queue.rb",
     "lib/tweetable/search.rb",
     "lib/tweetable/twitter_client.rb",
     "lib/tweetable/twitter_streaming_client.rb",
     "lib/tweetable/url.rb",
     "lib/tweetable/user.rb",
     "pkg/tweetable-0.1.7.gem",
     "script/console",
     "script/destroy",
     "script/generate",
     "spec/collection_spec.rb",
     "spec/fixtures/blank.json",
     "spec/fixtures/flippyhead.json",
     "spec/fixtures/follower_ids.json",
     "spec/fixtures/friend_ids.json",
     "spec/fixtures/friends_timeline.json",
     "spec/fixtures/link_blank.json",
     "spec/fixtures/link_exists.json",
     "spec/fixtures/rate_limit_status.json",
     "spec/fixtures/search.json",
     "spec/fixtures/user_timeline.json",
     "spec/fixtures/verify_credentials.json",
     "spec/link_spec.rb",
     "spec/message_spec.rb",
     "spec/persistable_spec.rb",
     "spec/queue_spec.rb",
     "spec/search_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/tweetable_spec.rb",
     "spec/twitter_client_spec.rb",
     "spec/twitter_streaming_client_spec.rb",
     "spec/user_spec.rb",
     "tweetable.gemspec"
  ]
  s.homepage = %q{http://github.com/flippyhead/tweetable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Track twitter messages and users in memory using Redis}
  s.test_files = [
    "spec/collection_spec.rb",
     "spec/link_spec.rb",
     "spec/message_spec.rb",
     "spec/persistable_spec.rb",
     "spec/queue_spec.rb",
     "spec/search_spec.rb",
     "spec/spec_helper.rb",
     "spec/tweetable_spec.rb",
     "spec/twitter_client_spec.rb",
     "spec/twitter_streaming_client_spec.rb",
     "spec/user_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<logging>, [">= 0"])
      s.add_runtime_dependency(%q<twitter>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<logging>, [">= 0"])
      s.add_dependency(%q<twitter>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<logging>, [">= 0"])
    s.add_dependency(%q<twitter>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

