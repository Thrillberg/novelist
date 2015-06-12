require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to the queue page" do
      set_current_user
      book = Fabricate(:book)
      post :create, book_id: book.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the book" do
      set_current_user
      book = Fabricate(:book)
      post :create, book_id: book.id
      expect(QueueItem.first.book).to eq(book)
    end

    it "creates the queue item that is associated with the signed in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      book = Fabricate(:book)
      post :create, book_id: book.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it "puts the book as the last one in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tuscan_sun = Fabricate(:book)
      Fabricate(:queue_item, book: tuscan_sun, user: alice)
      agony_and_ecstasy = Fabricate(:book)
      post :create, book_id: agony_and_ecstasy.id
      agony_and_ecstasy_queue_item = QueueItem.where(book_id: agony_and_ecstasy.id, user_id: alice.id).first
      expect(agony_and_ecstasy_queue_item.position).to eq(2)
    end

    it "does not add the book to the queue if the book is already in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      tuscan_sun = Fabricate(:book)
      Fabricate(:queue_item, book: tuscan_sun, user: alice)
      agony_and_ecstasy = Fabricate(:book)
      post :create, book_id: tuscan_sun.id
      agony_and_ecstasy_queue_item = QueueItem.where(book_id: agony_and_ecstasy.id, user_id: alice.id).first
      expect(alice.queue_items.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, book_id: 3 }
    end

    it "creates three queue items associated with the selected country" do
      set_current_user
      country = Fabricate(:country)
      book1 = Fabricate(:book, country: country)
      book2 = Fabricate(:book, country: country)
      book3 = Fabricate(:book, country: country)
      post :create, book_id: book1.id, country_id: country.id
      post :create, book_id: book2.id, country_id: country.id
      post :create, book_id: book3.id, country_id: country.id

      expect(QueueItem.count).to eq(3)
    end
  end

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
      queue_item1 = Fabricate(:queue_item, user: alice, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if the queue item is not the current user's queue" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end
  end

  describe "POST update_queue" do

    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}] }
    end

    context "with valid inputs" do
      let(:alice) { Fabricate(:user) }
      let(:book) { Fabricate(:book) }
      let(:queue_item1) {Fabricate(:queue_item, user: alice, position: 1, book: book) }
      let(:queue_item2) {Fabricate(:queue_item, user: alice, position: 2, book: book) }

      before { set_current_user(alice) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end

      it "only allows three items in the queue"

    end

    context "with invalid inputs" do
      let(:alice) { alice = Fabricate(:user) }
      let(:book) { Fabricate(:book) }
      let(:queue_item1) {Fabricate(:queue_item, user: alice, position: 1, book: book) }
      let(:queue_item2) {Fabricate(:queue_item, user: alice, position: 2, book: book) }
      
      before { set_current_user(alice) }

      it "redirects to the queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with the queue items that do not belong to the current user" do
      it "does not change the queue items" do
        alice = Fabricate(:user)
        book = Fabricate(:book)
        set_current_user(alice)
        bob = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, book: book)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, book: book)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end