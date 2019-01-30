# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# user = User.create(fname: 'John', lname: 'Doe', email:'abc@mail.com')
# user2 = User.create(fname: 'tony', lname: 'stark', email:'tony@mail.com')
# user3 = User.create(fname: 'smith', lname: 'lynn', email:'smith@mail.com')
#admin account
User.create(fname: 'Admin', lname: 'Admin', email:'admin@admin.com',password:'adminpass',phonenum: '416666666', address:'123 fake street',email_confirmed: true,  admin: true)
# items = Item.create([{name: 'pencil', descr: 'brand new condition', status: 'lentout',user_id: user3.id},
# 	{name: 'eraser', descr: 'brand new condition', status: 'lentout',user_id: user3.id},
# 	{name: 'ps4 console', descr: 'brand new condition', status: 'available' ,user_id: user2.id},
# 	{name: 'god of war 4', descr: 'brand new condition', status: 'available' ,user_id: user2.id},
# 	{name: 'spider-man new universe', descr: 'brand new condition', status: 'available', user_id: user2.id}])
# WishList.create([
# 	{item_id: items[3].id, user_id: user.id},
# 	{item_id: items[4].id, user_id: user.id}])
# BorrowedItem.create([{item_id: items[1].id, user_id: user.id, due_on: "2018/11/11"},
# 	{item_id: items[0].id, user_id: user.id, due_on: "2018/12/02"}])
# OnHoldItem.create([{item_id: items[2].id, user_id: user.id, req_on: "2018/10/31"}])
