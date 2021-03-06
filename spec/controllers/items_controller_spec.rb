require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  describe 'Get #index' do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status "200"
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'can save' do
      it 'count up product' do
        expect do
          post :create, params: {item: FactoryBot.attributes_for(:item)}.to change(Item,:count).by(1)
        end
      end
    end

    context 'can not save' do
      it 'does not count up' do
        expect do
          post :create,params: {item: FactoryBot.attributes_for(:item,name: nil, price: nil)}
        end.not_to change(Item,:count)
      end
    end
  end

  describe 'Get #show' do

    it "responds successfully" do
      expect(response).to be_success
    end

    it "returns a 200 response" do
      expect(response).to have_http_status "200"
    end
  end

  describe "GET #edit" do
    it 'インスタンス変数取得確認' do
      item = create(:item)
      get :edit, params: { id: item }
      expect(assigns(:item)).to eq item
    end
    it 'editビュー描画' do
      item = create(:item)
      get :edit, params: { id: item }
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    it 'インスタンス変数取得後、変更の保存確認' do
      item = create(:item)
      patch :update, params: { id: item, item: attributes_for(:item, name: 'hogefuga') }
      item.reload
      expect(item.name).to eq 'hogefuga'
    end
  end
end
