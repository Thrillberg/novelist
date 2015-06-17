require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    italy = Fabricate(:country)
    tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", country: italy)
    agony_and_ecstasy = Fabricate(:book, title: "The Agony and the Ecstasy", country: italy)
    italy_book = Fabricate(:book, title: "A random book about Italy", country: italy)

    sign_in

    add_book_to_queue(tuscan_sun)
    expect_book_to_be_in_queue(tuscan_sun)

    visit book_path(tuscan_sun)
    expect_link_not_to_be_seen("+ My Queue")

    add_book_to_queue(agony_and_ecstasy)
    add_book_to_queue(italy_book)

    set_book_position(tuscan_sun, 3)
    set_book_position(agony_and_ecstasy, 2)
    set_book_position(italy_book, 1)

    update_queue

    expect_book_position(italy_book, 1)
    expect_book_position(agony_and_ecstasy, 2)
    expect_book_position(tuscan_sun, 3)
  end

  def expect_book_to_be_in_queue(book)
    page.should have_content(book.title)
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content(link_text)
  end

  def update_queue
    click_button "Update Queue"
  end

  def add_book_to_queue(book)
    visit home_path
    find("a[href='/books/#{book.id}']").click
    click_link("+ My Queue")
  end

  def set_book_position(book, position)
    within(:xpath, "//tr[contains(.,'#{book.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_book_position(book, position)
    expect(find(:xpath, "//tr[contains(.,'#{book.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end