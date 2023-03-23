class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @countries = CS.countries
    @states = []
    @cities = []
  end

  # GET /users/1/edit
  def edit
    @countries = CS.countries
    @states = CS.states(@user.country.parameterize.to_sym)
    @cities = CS.cities(@user.state.parameterize.to_sym, @user.country.parameterize.to_sym)
    puts @state
    puts @cities
  end

  # POST /users or /users.json
  def create
    authy = Authy::API.register_user(:email => 'new_user@email.com', :cellphone => "405-342-5699", :country_code => "57")
    response = Authy::API.request_sms(:id => authy.id)

if authy.ok?
  puts authy.id
else
  puts authy.errors
end
    # puts params
    # @user = User.new(user_params)

    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to user_url(@user), notice: "User was successfully created." }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
   
  def state
   country = params['e'].parameterize.to_sym   
   @state = CS.states(country)
   state = @state.to_a[0][0].to_s.parameterize.to_sym
   @city = CS.cities(state, country)
   render json: [@state, @city]
  end
  def city
    city = params['e'].parameterize.to_sym
    country = params['country'].parameterize.to_sym
    @cities = CS.cities(city, country)
    render json:  @cities
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :country, :state, :city)
    end
end
