class Poster < ApplicationRecord
  scope :sort_asc, -> (sort) {order(created_at: :asc) if sort=="asc"}
  scope :sort_dsc, -> (sort) {order(created_at: :desc) if sort=="desc"}
  scope :filter_by_name, -> (name) {where("name ILIKE '%#{name}%'").order(name: :asc) if name.present?}
  scope :filter_by_min_price, -> (min_price) {where("price >= #{min_price}") if min_price.present?}
  scope :filter_by_max_price, -> (max_price) {where("price <= #{max_price}") if max_price.present?}
end