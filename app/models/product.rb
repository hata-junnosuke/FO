class Product < ApplicationRecord
  # 今回の課題には関係ないがつけるのが一般的と考え文字数制限を入れる
  validates :code, presence: true, length: { maximum: 10 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :price,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
