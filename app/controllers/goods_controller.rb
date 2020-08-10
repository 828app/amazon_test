class GoodsController < ApplicationController
  def search
    request = Vacuum.new(marketplace: 'JP',
                         access_key: ENV['AWS_ACCESS_KEY_ID'],
                         secret_key: ENV['AWS_SECRET_KEY'],
                         partner_tag: ENV['ASSOCIATE_TAG'])
    @response = request.search_items(title: 'startup',min_price:200)
    @response = @response.to_h
    @aaa= request.get_items(
      item_ids: ['B0199980K4', 'B000HZD168', 'B01180YUXS', 'B00BKQTA4A'],
      resources: ['Images.Primary.Small', 'ItemInfo.Title', 'ItemInfo.Features',
              'Offers.Summaries.HighestPrice' , 'ParentASIN']
)
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
