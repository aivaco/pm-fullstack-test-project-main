# frozen_string_literal: true

module SnapshotsHelper
  def formatted_nodes(links)
    senders = links.map(&:sender).uniq
    receivers = links.map(&:receiver).uniq
    senders.union(receivers).map { |value| { id: value } }
  end

  def formatted_links(links)
    formatted_links = []

    links.each do |link|
      index = formatted_links.find_index { |h| h[:source] == link.sender && h[:target] == link.receiver }

      if index
        formatted_links[index][:topics].push(link.topic)
      else
        formatted_links.push({ source: link.sender, target: link.receiver, topics: [link.topic] })
      end
    end
    formatted_links
  end
end
