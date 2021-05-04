# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Creating First User"
User.find_or_create_by(email: "super.admin@tesmem.com", role: "super_admin") do |user|
    user.password = "3XTh&qd&"
end

# # Sort sub_categories of RESERVED_ICONS 
# Category.find_by(
#     title: 'RESERVED_ICONS'
# ).sub_categories.collect{|sub_category| 
#     SortReservedIcon.find_or_create_by(
#         sub_category_id: sub_category.id,
#         title: sub_category.title
#         )
#     }