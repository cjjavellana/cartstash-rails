require 'rails_helper'

describe 'Index Page' do

  it 'displays the main page when root url is visited' do
    visit root_path
    expect(page).to have_selector('.login-btn')
    expect(page).to have_selector('.signup-btn')
    expect(page).to have_selector('.product-item')
    expect(page).to have_selector('.left-menu')
  end

end