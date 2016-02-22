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


# Method to randomize all people
  def random_people
@people = Person.all

@people.each do |person|
  person.sensei = false
  person.save
end

    idperson = @people.map{|x| x.id}
    if Group.all.count>0
      while idperson.count >0
        Group.all.each do |grp|
          a = idperson.sample
          Person.find(a).update_attributes(group_id: grp.id) unless a.nil?
          ## summarize that:
          # b = Person.find(a)
          # b.group_id = grp.id
          # b.save
          idperson.delete(a)
        end
      end
      else
        redirect_to :root, notice: "ther have to be a least one group .Dumbass!"
      end
      redirect_to :root, notice: "Yataaaaa ! All has been randomized!!!"
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
