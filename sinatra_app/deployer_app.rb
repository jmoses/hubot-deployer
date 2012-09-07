class String
  def blank?
    size.zero?
  end
end

class NilClass
  def blank?
    true
  end
end

class DeployerApp < Sinatra::Base
  module RepoUpdater
    BASE = File.read('.basedir').strip

    module_function
    def update(repo_name)
      do_in(repo_name, "git pull origin master")
    end

    def bundle(repo_name)
      do_in(repo_name, "bundle")
    end

    def deploy(repo_name, environment, task = "deploy")
      unless success?(result = update(repo_name))
        return "Failed updating the repo: #{result}"
      end

      unless success?(result = bundle(repo_name))
        return "Failed bundling: #{result}"
      end

      unless success?(result = do_in(repo_name, "bundle exec cap #{environment} #{task}"))
        return "Failed deploying: #{result}"
      end

      return "Deploy complete."
    end

    def do_in(repo_name, command)
      `cd #{File.join BASE, repo_name} && #{command} 2>&1`
    end

    def success?(response)
      $?.exitstatus.zero?
    end


  end

  #pass in the repo name and deploy that shit
  get '/deploy/:name/:environment/?:command' do
    result = RepoUpdater.deploy(params[:name], params[:environment], params[:command].blank? ? params[:command] : 'deploy')

    if result != "Deploy complete."
      [500, result]
    else
      result
    end
  end
end
