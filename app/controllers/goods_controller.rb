class GoodsController < ApplicationController
  def search
    Amazon::Ecs.options = {
          associate_tag: ENV['ASSOCIATE_TAG'],
          AWS_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          AWS_secret_key: ENV['AWS_SECRET_KEY']
    }
    if params[:keyword].present?

      # Amazon::Ecs::Responseオブジェクトの取得
      goods = Amazon::Ecs.item_search(
        params[:keyword],
        search_index:  'All',
        dataType: 'script',
        response_group: 'ItemAttributes, Images',
        country:  'jp',
              )

      # 本のタイトル,画像URL, 詳細ページURLの取得
      @goods = []
      goods.items.each do |item|
        good = Good.new(
          item.get('ItemAttributes/Title'),
          item.get('LargeImage/URL'),
          item.get('DetailPageURL'),
        )
        @goods << good
      end
    end
  end
end
