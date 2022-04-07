class ChangeColumnDefaultToViewCounts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :view_counts, :count, from: nil, to: 0
  end
end
