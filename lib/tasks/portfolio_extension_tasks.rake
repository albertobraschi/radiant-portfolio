namespace :radiant do
  namespace :extensions do
    namespace :portfolio do
      
      desc "Runs the migration of the Portfolio extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PortfolioExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PortfolioExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Portfolio to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[PortfolioExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PortfolioExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
