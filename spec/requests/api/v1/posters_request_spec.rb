require 'rails_helper'

describe "Posters API", type: :request do
  it "sends a list of posters" do
    Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
    
    get "/api/v1/posters"

    expect(response).to be_successful

    posters_hash = JSON.parse(response.body, symbolize_names: true)
    posters = posters_hash[:data]

    expect(posters.count).to eq(1)

    posters.each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_a(Integer)

      expect(poster).to have_key(:type)
      expect(poster[:type]).to be_a(String)

      expect(poster[:attributes]).to have_key(:name)
      expect(poster[:attributes][:name]).to be_a(String)

      expect(poster[:attributes]).to have_key(:description)
      expect(poster[:attributes][:description]).to be_a(String)

      expect(poster[:attributes]).to have_key(:price)
      expect(poster[:attributes][:price]).to be_a(Float)

      expect(poster[:attributes]).to have_key(:year)
      expect(poster[:attributes][:year]).to be_a(Integer)

      expect(poster[:attributes]).to have_key(:vintage)
      expect([true, false].include?(poster[:attributes][:vintage])).to eq(true)

      expect(poster[:attributes]).to have_key(:img_url)
      expect(poster[:attributes][:img_url]).to be_a(String)
    end
  end

  it "can get one poster by its id" do
    id = Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")[:id]

    get "/api/v1/posters/#{id}"
  
    poster = JSON.parse(response.body, symbolize_names: true)
    attributes = poster[:attributes]
  
    expect(response).to be_successful
  
    expect(poster).to have_key(:id)
    expect(poster[:id]).to be_an(Integer)
  
    expect(poster).to have_key(:type)
    expect(poster[:type]).to be_a(String)
  
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  
    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)

    expect(attributes).to have_key(:price)
    expect(attributes[:price]).to be_a(Float)

    expect(attributes).to have_key(:year)
    expect(attributes[:year]).to be_a(Integer)

    expect(attributes).to have_key(:vintage)
    expect([true, false].include?(attributes[:vintage])).to eq(true)

    expect(attributes).to have_key(:img_url)
    expect(attributes[:img_url]).to be_a(String)
  end
  
  it "can create a new poster" do

    post "/api/v1/posters", params: {name: "REGRET", 
      description: "Hard work rarely pays off.", 
      price: 89.00, 
      year: 2018, 
      vintage: true, 
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"}
    created_poster = Poster.last

    expect(response).to be_successful
    
    expect(created_poster[:name]).to be_a(String)
    expect(created_poster[:description]).to be_a(String)   
    expect(created_poster[:price]).to be_a(Float)
    expect(created_poster[:year]).to be_a(Integer)
    expect(created_poster[:vintage]).to be_in([true, false])
    expect(created_poster[:img_url]).to be_a(String)
  end


  it "can update an existing poster" do
    id = Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")[:id]
    previous_name = Poster.last[:name]
   
    patch "/api/v1/posters/#{id}", params: { name: "INCOMPETENCE" }
    poster = Poster.find_by(id: id)
  
    expect(response).to be_successful
    expect(poster[:name]).to_not eq(previous_name)
    expect(poster[:name]).to eq("INCOMPETENCE")
  end
  
  it "can destroy a poster" do
    poster = Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  
    expect(Poster.count).to eq(1)
  
    delete "/api/v1/posters/#{poster.id}"
  
    expect(response).to be_successful
    expect(Poster.count).to eq(0)
    expect{ Poster.find(poster.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can display a count of returned posters" do
    Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
    
    get "/api/v1/posters"

    expect(response).to be_successful

    posters_hash = JSON.parse(response.body, symbolize_names: true)
    posters = posters_hash[:data]
    meta = posters_hash[:meta]

    expect(posters.count).to eq(1)
    expect(meta).to have_key(:count)
    expect(meta[:count]).to eq(posters.count)
  end

  it "can sort returned posters in ascending order by created_at" do
    Poster.create(name: "Poster A", price: 10.0, year: 2000, vintage: false, img_url: "url1")
    Poster.create(name: "Poster B", price: 20.0, year: 1990, vintage: true, img_url: "url2")
    Poster.create(name: "Poster C", price: 15.0, year: 2010, vintage: false, img_url: "url3")

    get "/api/v1/posters", params: { sort: 'created_at_asc' }

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(posters.map { |poster| poster[:attributes][:name] }).to eq(["Poster A", "Poster B", "Poster C"])
  end

  it "can sort returned posters in descending order by created_at" do
    Poster.create(name: "Poster A", price: 10.0, year: 2000, vintage: false, img_url: "url1")
    Poster.create(name: "Poster B", price: 20.0, year: 1990, vintage: true, img_url: "url2")
    Poster.create(name: "Poster C", price: 15.0, year: 2010, vintage: false, img_url: "url3")

    get "/api/v1/posters", params: { sort: 'created_at_desc' }

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(posters.map { |poster| poster[:attributes][:name] }).to eq(["Poster C", "Poster B", "Poster A"])
  end

  it "can filter returned posters by name" do
    Poster.create(name: "Poster A", price: 10.0, year: 2000, vintage: false, img_url: "url1")
    Poster.create(name: "Poster B", price: 20.0, year: 1990, vintage: true, img_url: "url2")
    Poster.create(name: "Poster C", price: 15.0, year: 2010, vintage: false, img_url: "url3")

    get "/api/v1/posters", params: { name: 'Poster B' }

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(posters.count).to eq(1)
    expect(posters.first[:attributes][:name]).to eq("Poster B")
  end

  it "can filter returned posters by minimum price" do
     Poster.create(name: "Poster A", price: 10.0, year: 2000, vintage: false, img_url: "url1")
     Poster.create(name: "Poster B", price: 20.0, year: 1990, vintage: true, img_url: "url2")
     Poster.create(name: "Poster C", price: 15.0, year: 2010, vintage: false, img_url: "url3")

     get "/api/v1/posters", params: { min_price: 15.0 }

     expect(response).to be_successful

     posters = JSON.parse(response.body, symbolize_names: true)[:data]
     expect(posters.count).to eq(2)
     expect(posters.map { |poster| poster[:attributes][:price] }).to eq([20.0, 15.0])
  end

  it "can filter returned posters by maximum price" do
     Poster.create(name: "Poster A", price: 10.0, year: 2000, vintage: false, img_url: "url1")
     Poster.create(name: "Poster B", price: 20.0, year: 1990, vintage: true, img_url: "url2")
     Poster.create(name: "Poster C", price: 15.0, year: 2010, vintage: false, img_url: "url3")

     get "/api/v1/posters", params: { max_price: 15.0 }

     expect(response).to be_successful

     posters = JSON.parse(response.body, symbolize_names: true)[:data]
     expect(posters.count).to eq(2)
     expect(posters.map { |poster| poster[:attributes][:price] }).to eq([10.0, 15.0])
  end
end