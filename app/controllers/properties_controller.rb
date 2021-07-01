class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show edit update destroy reserve reservations ]

  # GET /properties or /properties.json
  def index
    @properties = Property.all
    if search_params[:owner_properties]
      @properties = @properties.where(user: current_user)
    else
      @properties = @properties.where.not(user: current_user)
    end
    if search_params[:start_date]&.present? && search_params[:end_date]&.present?
      @properties = @properties.where('not exists (:reservations)',
                                     reservations: Reservation.where('properties.id = reservations.property_id').
                                       where('end_date >= :sd and start_date <= :ed',
                                             sd: search_params[:start_date],
                                             ed: search_params[:end_date]))
    end
    if search_params[:postal_code]&.present?
      @properties = @properties.where(postal_code: search_params[:postal_code])
    end
    @properties
  end

  # GET /properties/1 or /properties/1.json
  def show
    @reservation = Reservation.new
    @property
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
    unless user_signed_in? && @property.user == current_user
      redirect_to @property
    end
  end

  # POST /properties or /properties.json
  def create
    # @property = Property.new(property_params)
    @property = current_user.properties.build(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1 or /properties/1.json
  def update
    respond_to do |format|
      if user_signed_in? && @property.owner == current_user
        if @property.update(property_params)
          format.html { redirect_to @property, notice: "Property was successfully updated." }
          format.json { render :show, status: :ok, location: @property }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @property.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @property, alert: "Unauthorized to update property."}
        format.json { render :show, status: :unauthorized, location: @property }
      end
    end
  end

  # DELETE /properties/1 or /properties/1.json
  def destroy
    respond_to do |format|
      if user_signed_in? && @property.owner == current_user
        @property.destroy
        format.html { redirect_to properties_url, notice: "Property was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to properties_url, alert: "Unauthorized to delete property."}
        format.json { render :show, status: :unauthorized, location: @property }
      end
    end
  end

  # POST /properties/1
  def reserve
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.property = @property
    respond_to do |format|
      if @reservation.save
        @reservations = current_user.reservations
        format.html { redirect_to @reservation, notice: "Reservation was successfully created." }
        format.json { render :index, status: :created, location: @reservation }
      else
        format.html { render :show, status: :unprocessable_entity, location: @property }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /properties/1/reservations
  def reservations
    if user_signed_in? && @property.owner == current_user
      @reservations = @property.reservations
      respond_to do |format|
        format.html { render 'reservations/index', status: :ok }
        format.json { render json: @reservations }
      end
    else
      redirect_to properties_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      begin
        id = params[:id] || params[:property_id]
        @property = Property.find(id)
      rescue ActiveRecord::RecordNotFound
        redirect_to action: "index"
      end
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:address_line_1, :address_line_2, :city, :state, :postal_code, :description)
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end

    def search_params
      params.permit(:start_date, :end_date, :postal_code, :owner_properties)
    end

end
