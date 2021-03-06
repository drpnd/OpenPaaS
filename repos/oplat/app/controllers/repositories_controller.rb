class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:create, :destroy]

  # # GET /repositories
  # # GET /repositories.json
  # def index
  #   @repositories = Repository.all
  # end

  # # GET /repositories/1
  # # GET /repositories/1.json
  # def show
  # end

  # # GET /repositories/new
  def new
    @repository = current_user.repositories.build
    p @repository
    @repository
  end

  # # GET /repositories/1/edit
  # def edit
  # end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = current_user.repositories.build(repository_params)
    if @repository.save
        flash[:success] = "Repository was successfully created."
      redirect_to root_url
    else
      respond_to do |format|
        flash[:error] = "Failed."
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
        # redirect_to root_url
      end
    end

    # @repository = Repository.new(repository_params)
    # respond_to do |format|
    #   if @repository.save
    #     format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
    #     format.json { render :show, status: :created, location: @repository }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @repository.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  # def update
  #   respond_to do |format|
  #     if @repository.update(repository_params)
  #       format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @repository }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @repository.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  # def destroy
  #   @repository.destroy
  #   respond_to do |format|
  #     format.html { redirect_to repositories_url, notice: 'Repository was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:name, :user_id)
    end

    def correct_user
      @repositories = current_user.repositories.find_by(id: params[:id])
      redirect_to root_url if @repositories.nil?
    end
end
