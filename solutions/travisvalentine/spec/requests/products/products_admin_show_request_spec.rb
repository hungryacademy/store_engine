require 'spec_helper'

describe "Product Show Requests" do
  context "as an admin" do
    let!(:products) do
      [product_one = Fabricate(:product),
       product_two = Fabricate(:product),
       product_three = Fabricate(:product)
     ]
    end
    let!(:retired) do
      [retired_one = Fabricate(:product, :retired => true),
       retired_two = Fabricate(:product, :retired => true)
      ]
    end

    let(:category) { Fabricate(:category) }

    before(:each) do
      @user = Fabricate(:user,
                        :password => 'password',
                        :admin => true)
      login(@user)
    end

    it "shows a link to edit a product" do
      product = products.first
      visit "/products/#{product.id}"
      within("#admin_bar") do
        page.should have_link('Edit Product', href: edit_product_path(product))
      end
    end

    it "shows a link to delete a product" do
      product = products.first
      visit "/products/#{product.id}"
      within("#admin_bar") do
        page.should have_link('Delete Product', href: product_path(product))
      end
    end

    it "shows a link to all products" do
      product = products.first
      visit "/products/#{product.id}"
      within("#index_categories") do
        page.should have_link('All Products', href: products_path)
      end
    end

    it "allows you to remove a product" do
      product = products.first
      visit "/products/#{product.id}"
      click_link("Delete Product")
      current_path.should == "/products"
      Product.all.should_not include(product)
    end

    it "has a link to put the product on sale" do
      product = products.first
      visit product_path(product)
      page.should have_link("Put on sale")
    end

    it "takes me to the form to create a sale for the product" do
      product = products.first
      visit product_path(product)
      click_link_or_button("Put on sale")
      current_path.should == new_sale_path
    end
  end
end
