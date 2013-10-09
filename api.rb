require 'grape'
require 'grape-swagger'
require 'pp'

module Scegratoo
  RootDir = Dir.pwd
  Projects = {1 => 'First'}

  class API < Grape::API
    prefix 'api'
    version 'v1', using: :path
    format :json


    helpers do
      def logger
        API.logger
      end

      def logParams params
        params.each_pair { |name, val|
          puts "#{name}: #{val}\n"
        }

        puts
      end

      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    # TODO: remove in production
    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end


    # resource :files do
    #   get '/' do
    #     pp params
    #     {
    #       files: 'bla'
    #     }
    #   end
    # end

    resource :courses do
      get '/' do
        'Root'
      end

      get ':course' do
        "Course: #{params[:course]}"
      end

      desc "Create a course."
      params do
        requires :title, type: String, desc: "Your course."
        optional :url, type: String, desc: "URL to your course."
      end
      post do
        logParams params

        true
      end

      put do
        pp logger

        true
      end

    end

    resource :projects do
      get '/' do
        pp params
        Dir.open RootDir do |d|
          {
            projects: d.entries.sort
          }
        end
      end

      resource ':project' do

        resource :entries do
          params do
            requires :project
          end

          get do
            Dir.chdir RootDir
            Dir.chdir params[:project]
            Dir.glob("**/*")
          end

          resource ':entry' do
            params do
              requires :project, :entry
            end

            get do
              pp params
              Dir.chdir RootDir
              Dir.chdir params[:project]
              path = params[:entry]

              if params[:format]
                path += '.' + params[:format]
              end

              File.open path, 'r' do |f|
                {
                  content: f.read.chop
                }
              end
            end
          end
        end

        # resource :folders do
          # get do
          #   pp params
          #   pp Dir.pwd
          #   project = params[:project]
          #   Dir.open project do |d|
          #     dirs = d.select do |e|
          #       File.directory? e
          #     end
          #     {
          #       folders: dirs,
          #       currentProject: project
          #     }
          #   end
          # end

          # resource ':folder' do
          #   get do

          #   end
          # end
        # end
      end

    #   get ':project' do
    #     pp params
    #     project = params[:project]
    #     Dir.mkdir project unless Dir.exists? project
    #     Dir.open project do |d|
    #       {
    #         files: d.entries.sort,
    #         currentProject: params[:project]
    #       }
    #     end
    #   end

    #   get ':project/:file' do
    #     pp params
    #     project, file, format = params.values_at('project', 'file', 'format')
    #     File.open "#{project}/#{file}.#{format}", 'a+' do |f|
    #       {
    #         file: file,
    #         content: f.read.chop,
    #         format: format
    #       }
    #     end
    #   end

    #   get '*' do
    #     pp params
    #   end
    end

    # namespace :statuses do
    #   params do
    #     requires :user_id, type: Integer, desc: "A user ID."
    #   end
    #   namespace ":user_id" do
    #     desc "Retrieve a user's status."
    #     params do
    #       requires :status_id, type: Integer, desc: "A status ID."
    #     end
    #     get ":status_id" do
    #       User.find(params[:user_id]).statuses.find(params[:status_id])
    #     end
    #   end
    # end

    add_swagger_documentation({api_version: 'v1'})
  end
end
