class IntervalsController < ApplicationController
    before_filter :authenticate_user!
    before_filter :require_nda
    before_filter :find_interval, :only => [:show, :update, :edit]
    
	def index
    @filters = Interval.filters
    @intervals = Interval.search(params).page params[:page]

    render 'index'
  end

  def show
    @applied_tags= @interval.taggings

    #@unapplied_phenomenon = Code.phenomenon.unapplied(@interval.id)
    @applied_phenomenon = @interval.codings.phenomenon
    @all_phenomenon = Code.phenomenon.all

    @applied_people = @interval.codings.people
    @all_people = Code.people.all
    #@unapplied_people = Code.people.unapplied(@interval.id)

    respond_to do |format|
      format.sprite { send_sprite }
      format.jpg { send_thumbnail }
      format.html {  render "show"}
      format.m4v { send_video}
    end

  end

  def new
    @interval = Interval.new
    render "new"
  end

  def edit
    render "edit"
  end


  def create
    @interval = Interval.new(params[:interval])
    if @interval.save
      redirect_to(@interval, :notice => 'Interval was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @interval.attributes = {'tag_ids' => []}.merge(params[:interval] || {})
    
    if @interval.update_attributes(params[:interval])
      redirect_to(@interval, :notice => 'Interval was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @interval = Interval.find(params[:id])
    @interval.destroy
    redirect_to(intervals_url)
  end

  private
  def find_interval
    @interval = Interval.find(params[:id])
  end
  
  def send_thumbnail
    send_file(@interval.thumbnail_file, :type => 'image/jpeg', :disposition => 'inline', :url_based_filename => true) 
  end
  
  def send_sprite
    
    send_file(@interval.sprite_file, :type => 'image/jpeg', :disposition => 'inline', :url_based_filename => true)
  end
  
  def send_video
    send_file(@interval.video_file, :type => 'video/mp4', :disposition => 'inline', :url_based_filename => true) 
  end
  
end
