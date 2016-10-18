require 'spec_helper'

RSpec.describe ProjectsController, :type => :controller do
  render_views

  describe 'GET /' do
    it 'renders template for index' do
      project1 = create(:project)
      project2 = create(:project, title: "Java Tic-Tac-Toe")

      get :index

      expect(response.status).to eq(200)
      expect(response.body).to include(project1.title)
      expect(response.body).to include(project2.title)
    end
  end
end

