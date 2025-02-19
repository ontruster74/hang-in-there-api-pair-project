class PosterSerializer
  def self.format_posters(posters)
    final_result = {}
    final_result[:data] = []
    final_result[:meta] = {}

    posters.each do |poster|
      poster_details = {
        id: poster.id,
        type: poster.class(), 
        attributes: {
          name: poster.name,
          description: poster.description,
          price: poster.price,
          year: poster.year,
          vintage: poster.vintage,
          img_url: poster.img_url
        }
      }

      final_result[:data].push(poster_details)
    end

    final_result[:meta][:count] = final_result[:data].count
    return final_result
  end
end