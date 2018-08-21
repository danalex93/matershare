class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /workshops
  # GET /workshops.json
  def index
    @semesters = Semester.all
    if params[:semester_id].present?
      @workshops = Workshop.where(semester_id: params[:semester_id])
    end
  end

  # GET /workshops/1
  # GET /workshops/1.json
  def show
    @mentor = @workshop.mentor
    @quotas = @workshop.quotas - @workshop.enrollments.count
    @topics = @workshop.topics.last(5)
    @materials = @workshop.materials.last(5)
    @enrollment = Enrollment.new
  end

  # GET /workshops/new
  def new
    @workshop = Workshop.new
    @semesters = Semester.all.order(id: :desc)
  end

  # GET /workshops/1/edit
  def edit
    @mentors = Mentor.all
    @semesters = Semester.all
  end

  # POST /workshops
  # POST /workshops.json
  def create
    @workshop = Workshop.new(workshop_params)
    @workshop.mentor = current_mentor

    respond_to do |format|
      if @workshop.save
        format.html { redirect_to @workshop, notice: 'Workshop was successfully created.' }
        format.json { render :show, status: :created, location: @workshop }
      else
        format.html { render :new }
        format.json { render json: @workshop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workshops/1
  # PATCH/PUT /workshops/1.json
  def update
    respond_to do |format|
      if @workshop.update(workshop_params)
        format.html { redirect_to @workshop, notice: 'Workshop was successfully updated.' }
        format.json { render :show, status: :ok, location: @workshop }
      else
        format.html { render :edit }
        format.json { render json: @workshop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workshops/1
  # DELETE /workshops/1.json
  def destroy
    @workshop.destroy
    respond_to do |format|
      format.html { redirect_to workshops_url, notice: 'Workshop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workshop
      @workshop = Workshop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workshop_params
      params.require(:workshop).permit(:mentor_id, :semester_id, :title, :description, :schedule, :quotas)
    end
end
