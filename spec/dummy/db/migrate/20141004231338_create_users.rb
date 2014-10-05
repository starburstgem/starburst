class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :subscription
			t.timestamps
		end
	end
end
