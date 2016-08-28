class StaticController < ApplicationController
  
  def locations
    @locations = Location.where(visible: true).order(:country, :province, :name)
  end
  
  def events
    @events = Event.all
  end

  def not_found
    if Rails.env == "production" and !ExceptionBlacklist.path_on_404_blacklist(request.original_fullpath)
      ExceptionNotifier.notify_exception(Exception.new("404: #{request.original_fullpath}"), env: request.env)
    end
    render :err, status: 404
  end

  def robots
    if ENV.fetch("NO_ROBOTS") == "true"
      render plain: "User-agent: *\nDisallow: /\n"
    else
      render plain: "User-agent: *\nDisallow:\n"
    end
  end
  
  def stink
    if Access.admin?(session)
      redirect_to :admin_kingdoms
    else
      render :stink
    end
  end
  
  def stink_in
    if Access.is_admin_password(params[:password])
      Access.become_admin!(session)
      redirect_to :admin_kingdoms
    else
      @stink_status = "You're not very stinky."
      render :stink
    end
  end
  
  def stink_out
    Access.unbecome_admin!(session)
    reset_session
    redirect_to :root
  end

end
