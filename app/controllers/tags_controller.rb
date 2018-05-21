require '.config/environment'

class TagsController < ApplicationController

  get '/tags/:id' do
    if logged_in?
      @tag = Tag.find_by_id(params[:id])
      erb :'tags/show_tag'
    else
      redirect to '/'
    end
  end

end
