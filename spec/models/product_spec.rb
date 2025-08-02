RSpec.describe Product, type: :model do
  let(:product) { create(:product) }

  it "is valid with valid attributes" do
    expect(product).to be_valid
  end

  it "is valid with valid with 0 value in price" do
    expect(product).to be_valid
  end

  it "is not valid without a price" do
    product.price = nil
    expect(product).to_not be_valid
  end

  it "is not valid with a negative price" do
    product.price = -1
    expect(product).to_not be_valid
  end

  it "is not valid with string value in price" do
    product.price = 'string'
    expect(product).to_not be_valid
  end

  it "is not valid without a name" do
    product.name = nil
    expect(product).to_not be_valid
  end
end
