require 'rails_helper'
require 'byebug'

RSpec.describe UsersController, type: :controller do
    subject(:user) { User.create!(username: 'billiebob', password: 'password123') }

    describe 'GET#index' do
        it 'renders all users on index view' do 
            get :index
            expect(response).to render_template('index')
        end
    end

    describe 'GET#show' do
        it 'renders individual user show page' do
            get :show, params: { id: user.id }
            expect(response).to render_template('show')
        end
    end

    describe 'GET#new' do
        it 'renders new template' do 
            get :new
            expect(response).to render_template('new')
        end
    end

    describe 'POST#create' do
        context 'with valid params' do
            it 'redirects to the new users page' do
                post :create, params: { user: { username: "billiebob2", password: "password123" } }
                expect(response).to redirect_to(user_url(User.last))
            end
        end

        context 'with invalid params' do
            it 'password not long enough' do
                post :create, params: { user: { username: "billiebob3", password: "123" } }
                expect(response).to render_template('new')
                expect(flash[:errors]).to be_present
            end

            it 'username and password must be present' do
                post :create, params: { user: { username: "billiebob4", password: "" } }
                expect(response).to render_template('new')
                expect(flash[:errors]).to be_present
            end
        end
    end

    describe 'GET#edit' do
        it 'renders edit template' do 
            get :edit, params: { id: user.id }
            expect(response).to render_template('edit')
        end
    end

    describe 'PATCH#update' do
        context 'with valid params' do
            it 'returns new information and redirects to user page' do
                patch :update, params: { id: user.id, user: { username: "billiebob5", password: "password123" } }
                expect(user.username).to eq('billiebob5')
                expect(response).to redirect_to(user_url(user))
            end
        end

        context 'with invalid params' do
            it 'password not long enough' do
                patch :update, params: { user: { username: "billiebob", password: "123" } }
                expect(response).to render_template('edit')
                expect(flash[:errors]).to be_present
            end

            it 'username and password must be present' do
                patch :update, params: { user: { username: "billiebob", password: "" } }
                expect(response).to render_template('edit')
                expect(flash[:errors]).to be_present
            end
        end   
    end

    describe 'DELETE#destroy' do
        it 'destroys user from database' do
            delete :destroy, params: { id: user.id }
            expect{User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect(response).to redirect_to(users_url)
        end
    end

end