class GoodsController < ApplicationController
  def search
    if params[:keyword].present?
      request = Vacuum.new(marketplace: 'JP',
                           access_key: ENV['AWS_ACCESS_KEY_ID'],
                           secret_key: ENV['AWS_SECRET_KEY'],
                           partner_tag: ENV['ASSOCIATE_TAG'])
      keyword = params[:keyword]
      response = request.search_items(title: keyword,item_page:1,sort_by:'Relevance')
      puts response.to_h["SearchResult"]["Items"][0]["ASIN"]
      asin = []
      for num in 0..9 do
         asin.push(response.to_h["SearchResult"]["Items"][num]["ASIN"])
      end
       @items= request.get_items(
          item_ids: asin,
          resources: ['Images.Primary.Small', 'ItemInfo.Title'])
      @goods = []
      for i in 0..9 do
        @goods.push(@items.to_h["ItemsResult"]["Items"][i])
      end
    end
  end

  def tes
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
