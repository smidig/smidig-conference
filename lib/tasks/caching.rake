def delete_page_cache(path)
  file = "#{RAILS_ROOT}/public/#{path}"
  File.delete file if File.exist? file
end

namespace :cache do

  desc "Expire all cached pages"
  task :expire_all do
    %w(arrangoerene index lyntaler openspace).each do |view| 
      delete_page_cache("#{view}.html")
      delete_page_cache("pages/#{view}.html")
    end
  end
  
end

