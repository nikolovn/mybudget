require 'spec_helper'
include Warden::Test::Helpers

feature 'Enter Category' do
  #include AuthHelper
  #include DOMHelper
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'List parent expense categories' do
    parent_category = FactoryGirl.create(:expense_category, name: 'Car')
    FactoryGirl.create(:expense_category, name: 'Oil', parent: parent_category)

    visit 'expense_categories'

    expect(page).to have_content 'Car'
    expect(page).not_to have_content 'Oil'
  end

  scenario 'Click on parent category and list subcategories', js: true do
    parent = FactoryGirl.create(:expense_category, name: 'Car')
    FactoryGirl.create(:expense_category, name: 'Oil', parent: parent)
    FactoryGirl.create(:expense_category, name: 'Foot')
    FactoryGirl.create(:expense_category, name: 'Insurance', parent: parent)

    visit expense_categories_path
  
    expect(page).to have_content 'Car'
    expect(page).to have_content 'Foot'
    
    click_on 'Car'
    expect(page).to have_content 'Oil'
  end

  scenario 'Click on parent category and hide subcategories', js: true do
    parent_1 = FactoryGirl.create(:expense_category, name: 'Car')
    FactoryGirl.create(:expense_category, name: 'Oil', parent: parent_1)
    parent_2 = FactoryGirl.create(:expense_category, name: 'Foot')
    FactoryGirl.create(:expense_category, name: 'Soup', parent: parent_2)

    visit expense_categories_path
  
    expect(page).to have_content 'Car'
    expect(page).to have_content 'Foot'
    
    click_on 'Car'
  
    expect(page).to have_content 'Oil'

    click_on 'Foot'
    expect(page).to have_content 'Soup'

    click_on 'Car'
    expect(page).not_to have_content 'Oil'

    click_on 'Foot'
    expect(page).not_to have_content 'Soup'
  end

  scenario 'Add cetegory' do
    FactoryGirl.create(:expense_category, name: 'Food')

    visit 'expense_categories'
    
    click_on 'New category'

    fill_in 'expense_category_name', with: 'expense_category_1'
    page.select 'Food', from: 'expense_category_parent_id'

    click_on 'Create Expense category'
    expect(page).to have_content 'Expense category was successfully created.'
  end
  
  scenario 'Edit Category' do
    parent = FactoryGirl.create(:expense_category, name: 'Food' )
    FactoryGirl.create(:expense_category, name: 'Drinks', parent: parent)
    parent2 = FactoryGirl.create(:expense_category, name: 'Food2' )

    visit 'expense_categories'

    click_on('Edit', match: :first)
    fill_in 'expense_category_name', with: 'expense_category_1'
    page.select 'Food2', from: 'expense_category_parent_id'

    click_on 'Update Expense category'
    
    expect(page).to have_content 'Expense category was successfully updated.'
  end

  scenario 'Remove Category' do
    FactoryGirl.create(:expense_category, name: 'Food')
    FactoryGirl.create(:expense_category, name: 'Drinks')

    visit 'expense_categories'

    click_on('Delete', match: :first)

    expect(page).to have_content 'Drinks'
    expect(page).not_to have_content 'Food'
  end
end