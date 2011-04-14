class Photo < ActiveRecord::Base

  def self.fetch_and_update
    exists_ids  = []

    client = Instagram.client(:client_id => CLIENT_ID)

    TARGET_TAGS.each do |tag|
      next_max_id = nil
      begin
        begin
          result = client.tag_recent_media(tag, {
            :max_id => next_max_id,
            :count  => 150
          })
        rescue
          next
        end
        result.data.each do |data|
          id = data[:id]
          next unless exists_ids.index(id) == nil
          exists_ids.push(id)
          photo = find_or_initialize_by_id(id)
          photo.url    = data[:link]
          photo.low    = data[:images][:low_resolution][:url]
          photo.high   = data[:images][:standard_resolution][:url]
          photo.thumb  = data[:images][:thumbnail][:url]
          photo.score  = data[:likes][:count].to_i
          photo.filter = data[:filter]
          photo.created_time = Time.at(data[:created_time].to_i)
          photo.save!
        end
        next_max_id = result.pagination.next_max_id
        sleep 1
      end while next_max_id
    end

    photos = find(:all)
    photos.each do |photo|
      if exists_ids.index(photo.id) == nil
        photo.destroy
      end
    end
  end

end
