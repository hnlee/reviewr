require 'spec_helper'

describe 'user', :type => :feature do
  describe 'logged out index page' do
    it 'has a link to Google authentication' do 
      visit '/'

      expect(page).to have_link('Sign in with Google')
    end
  end

  describe 'logged in index page' do
    it 'has a link to log out' do
      OmniAuth.config.add_mock(:google_oauth2,
                               { uid: 'uid',
                                 info: { name: 'name',
                                         email: 'name@email.com' } })
      visit '/'
      click_link('Sign in with Google')

      expect(page).to have_link('Sign out')
    end
  end
end
