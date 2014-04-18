class IncomeCategoriesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_income_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @income_categories = IncomeCategory.all
    @income_transaction = IncomeTransaction.new
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @income_category = IncomeCategory.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @income_category = IncomeCategory.new(income_category_params)

    respond_to do |format|
      if @income_category.save
        format.html { redirect_to @income_category, notice: 'income_category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @income_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @income_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @income_category.update(income_category_params)
        format.html { redirect_to @income_category, notice: 'income_category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @income_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @income_category.destroy
    respond_to do |format|
      format.html { redirect_to income_categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_category
      @income_category = IncomeCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_category_params
      params.require(:income_category).permit(:name)
    end
end