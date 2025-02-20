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
    Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  
    get "/api/v1/posters/1"
  
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
    poster_params = {
      name: "REGRET", 
      description: "Hard work rarely pays off.", 
      price: 89.00, 
      year: 2018, 
      vintage: true, 
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    }

    headers = { "CONTENT_TYPE" => "application/json" }
    # We include this header to make sure that these params are passed as JSON rather than as plain text
  
    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
    created_poster = Poster.last
    
    created_poster_attributes = created_poster[:attributes]

    expect(response).to be_successful
    expect(created_poster_attributes[:name]).to eq(poster_params[:name])
    expect(created_poster_attributes[:description]).to eq(poster_params[:description])   
    expect(created_poster_attributes[:price]).to eq(poster_params[:price])
    expect(created_poster_attributes[:year]).to eq(poster_params[:year])
    expect(created_poster_attributes[:vintage]).to eq(poster_params[:vintage])
    expect(created_poster_attributes[:img_url]).to eq(poster_params[:img_url])
  end


  it "can update an existing poster" do
    id = Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d").id
    previous_name = Poster.last[:attributes].name
    poster_params = { name: "INCOMPETENCE" }
    headers = {"CONTENT_TYPE" => "application/json"}
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    
    patch "/api/v1/songs/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
    poster = Poster.find_by(id: id)
  
    expect(response).to be_successful
    expect(poster[:attributes][:name]).to_not eq(previous_name)
    expect(poster[:attributes][:name]).to eq("INCOMPETENCE")
  end
  
  it "can destroy a poster" do
    poster = Poster.create(name: "REGRET", description: "Hard work rarely pays off.", price: 89.00, year: 2018, vintage: true, img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  
    expect(Poster.count).to eq(1)
  
    delete "/api/v1/posters/#{poster.id}"
  
    expect(response).to be_successful
    expect(Poster.count).to eq(0)
    expect{ Poster.find(poster.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  xit "can display a count of returned posters" do
    
  end
  
end