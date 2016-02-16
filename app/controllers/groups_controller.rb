class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :minimum, only: [:random_people]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
    @people = Person.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to root_path, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to root_path, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




def random_people

@people = Person.all
@groups = Group.all

  maxByGroup = (@people.size / @groups.size).ceil + 1


  @people.each do |person|
    person.group_id = nil
    person.save
  end

  idGroup = []

  @groups.each do |group|
    idGroup << group.id
  end

  @people.each do |i|
    randomGroup = idGroup.sample
    i.group_id = randomGroup
      i.save
      if @people.where(group_id: randomGroup).size == maxByGroup
        idGroup.delete(randomGroup)
      end
  end
redirect_to root_path
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :room, :task)
    end

    def minimum
      if Group.all.size < 2
        redirect_to root_path, notice: 'You need minimum TWO groups to randomize.'
      end
    end


end
