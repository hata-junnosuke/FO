class Form::ProductCollection < Form::Base
  FORM_COUNT = 5 #ここで、作成したい登録フォームの数を指定
  attr_accessor :products #fields_for 第一引数に渡す変数にアクセスできる必要があるためこの記述が必要

  def initialize(attributes = {})
    super attributes # initializeの中でsuper attributesとしてますがそれが呼ばれる結果products_attributes=(attributes)も呼ばれます。
    self.products = FORM_COUNT.times.map { Product.new() } unless self.products.present?
  end

  # 今回更新したい変数は products なので、 products_attributes= という関数を実装している必要があります。
  def products_attributes=(attributes)
    self.products = attributes.map { |_, v| Product.new(v) }
  end

  # エラーがなければ有効と判断する
  def valid?
    super
    # target_productが有効でなければエラーを与える？
    unless target_products.map(&:valid?).all?
      target_products.flat_map { |p| p.errors.full_messages }.uniq.each do |message|
        errors.add(:base, message)
      end
    end
    errors.blank?
  end

  def save
    # valid?で有効と判断されなければ、falseを返す
    return false unless valid?
    # トランザクションで全てがsaveされればtrueとなる
    Product.transaction { target_products.each(&:save!) }
    true
  end

  def target_products
    products.select { |v| ActiveRecord::Type::Boolean.new.cast(v.availability) }
  end

  def check_code_unique
    errors.add(:base, '商品コードが重複しています') if target_products.pluck(:code).count - target_products.pluck(:code).uniq.count > 0
  end
end

