# hook to coordinate blog posts and pages into distinct urls,
# and remove duplicate multilanguage posts and pages
Jekyll::Hooks.register :site, :post_read do |site|
  if site.data.include?(site.active_lang)
    # Copy the language specific data, by recursively merging it with the default data.
    # See: https://www.ruby-forum.com/topic/142809
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    site.data = site.data.merge(site.data[site.active_lang], &merger)
  end
  site.collections.each do |_, collection|
    collection.docs = site.coordinate_documents(collection.docs)
  end
  site.pages = site.coordinate_documents(site.pages)
end
