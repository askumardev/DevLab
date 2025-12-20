class SectionsController < ApplicationController
  before_action :set_section

  def destroy
    @section.destroy
    head :no_content
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end
end